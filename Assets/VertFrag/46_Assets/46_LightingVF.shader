Shader "CourseShaders/46_LightingVF"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
	}
	SubShader
	{

		Pass
		{
			Tags { "LightMode"="ForwardBase" } // forward rendering (not deffered)

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"	// include lighting utilities

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 diff : COLOR0;		// diffuse color
			};

			sampler2D _MainTex;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				// simple lighting
				half3 worldNormal = UnityObjectToWorldNormal(v.normal); // local space normal to world space normal
				half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));	// _WorldSpaceLightPos0 is the position (for point lights) 
																				// or direction (for directional lights)
				o.diff = nl * _LightColor0; // _LigthColor0 is the color of the lights

				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col *= i.diff;	// apply lighting
				return col;
			}
			ENDCG
		}
	}
}
