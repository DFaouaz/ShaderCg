Shader "CourseShaders/MoreRayMarchingSphere"
{
	Properties
	{
		_Position("Position", Vector) = (0,0,0,0)
	}
	SubShader
	{
		Tags { "Queue"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};	

			struct v2f
			{
				float3 worldPos : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

			float4 _Position;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);					// position in clip space
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;	// position in world space

				return o;
			}

			#define STEPS 128
			#define STEP_SIZE 0.01
			#define SPHERE_POS float3(0,0,0)
			
			bool SphereHit(float3 p, float3 center, float radius) 
			{
				return distance(p, center) < radius;
			}

			float3 RaymarchHit(float3 position, float3 direction)
			{
				for (int i = 0; i < STEPS; i++) 
				{
					if (SphereHit(position, _Position + SPHERE_POS, 0.5))
						return position;

					position += direction * STEP_SIZE;
				}
				return float3(0, 0, 0);
			}


			fixed4 frag(v2f i) : SV_Target
			{
				float3 viewDir = normalize(i.worldPos - _WorldSpaceCameraPos);
				float3 depth = RaymarchHit(i.worldPos, viewDir);

				half3 worldNormal = normalize(depth - SPHERE_POS);	// depth minus the sphere position
				half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));

				if (length(depth) != 0)
				{
					depth *= nl * _LightColor0;
					return fixed4(depth, 1);
				}
				else return fixed4(1, 1, 1, 0);
			}
			ENDCG
		}
	}
}
