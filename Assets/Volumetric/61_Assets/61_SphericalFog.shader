Shader "CourseShaders/SphericalFog"
{
	Properties
	{
		_FogParams("Fog Center / Radius", Vector) = (0,0,0,0.5)
		_FogColor("Fog Color", Color) = (1,1,1,1)
		_InnerRatio("Inner Ratio", Range(0, 1)) = 0.5
		_Density("Density", Range(0,1)) = 0.5
	}
	SubShader
	{
		Tags { "Queue"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off
		Lighting Off
		ZWrite Off
		ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

			float CalculateFogIntensity(float3 center, float radius, float innerRatio, float density, float3 cameraPos, float3 viewDir, float maxDist) 
			{
				// calculate ray sphere intersection
				float3 localCam = cameraPos - center;
				float a = dot(viewDir, viewDir); // same as pow(vierDir, 2);
				float b = 2 * dot(viewDir, localCam);
				float c = dot(localCam, localCam) - radius * radius;

				float d = b * b - 4 * a * c; // discriminative
				if (d <= 0.0)
					return 0.0;
				
				float distSqr = sqrt(d);
				float d1 = max((-b - distSqr) / (2.0 * a), 0.0);
				float d2 = max((-b + distSqr) / (2.0 * a), 0.0);

				float backDepth = min(maxDist, d2);
				float smpl = d1;
				float steps = 10;
				float stepDist = (backDepth - d1) / steps;
				float stepContribution = density;

				float centerValue = 1 / (1 - innerRatio);

				float clarity = 1.0;
				for (int i; i < steps; i++)
				{
					float3 position = localCam + viewDir * smpl;
					float val = saturate(centerValue * (1.0 - length(position) / radius));
					float fogAmount = saturate(val * stepContribution);
					clarity *= (1.0 - fogAmount);
					smpl += stepDist;
				}

				return 1 - clarity;
			}

			struct v2f
			{
				float3 view : TEXCOORD0;
				float4 pos : SV_POSITION;
				float4 projPos : TEXCOORD1;
			};

			float4 _FogParams;
			fixed4 _FogColor;
			float _InnerRatio;
			float _Density;
			sampler2D _CameraDepthTexture;

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);					// position in clip space
				o.view = mul(unity_ObjectToWorld, v.vertex).xyz - _WorldSpaceCameraPos;	// position in world space
				o.projPos = ComputeScreenPos(o.pos);

				float inFrontOf = (o.pos.z / o.pos.w) > 0;
				o.pos.z *= inFrontOf;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				half4 color = half4(1,1,1,1);
				float depth = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos))));
				float3 viewDir = normalize(i.view);
				
				float fog = CalculateFogIntensity(_FogParams.xyz, _FogParams.w, _InnerRatio, _Density, _WorldSpaceCameraPos, viewDir, depth);

				color.rgb = _FogColor.rgb;
				color.a = fog;
				return color;
			}
			ENDCG
		}
	}
}
