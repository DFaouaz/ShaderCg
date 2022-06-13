Shader "CourseShaders/RayMarchingSphere"
{
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

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);					// position in clip space
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;	// position in world space
				return o;
			}

			#define STEPS 64
			#define STEP_SIZE 0.01
			
			bool SphereHit(float3 p, float3 center, float radius) 
			{
				return distance(p, center) < radius;
			}

			float RaymarchHit(float3 position, float3 direction)
			{
				for (int i = 0; i < STEPS; i++) 
				{
					if (SphereHit(position, float3(0, 0, 0), 0.5))
						return position;

					position += direction * STEP_SIZE;
				}
				return 0;
			}


			fixed4 frag(v2f i) : SV_Target
			{
				float3 viewDir = normalize(i.worldPos - _WorldSpaceCameraPos);
				float depth = RaymarchHit(i.worldPos, viewDir);

				if (depth != 0) return fixed4(1, 0, 0, 1);
				else return fixed4(1, 1, 1, 0);
			}
			ENDCG
		}
	}
}
