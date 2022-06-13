Shader "CourseShaders/47_ShadowsVF"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
	}
	SubShader
	{
		// Lighting Pass
		Pass
		{
			Name "Lighting and ShadowReceiver Pass"
			Tags { "LightMode"="ForwardBase" } // forward rendering (not deffered)

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
			// ignores lightmaps, directional lightmaps, dynamic lightmaps, vertex lighting

			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"	// include lighting utilities
			// needed for the shadow receiver fuctions
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;	// has to be named "pos" as TRANSFER_SHADOW macro needs it
				float2 uv : TEXCOORD0;
				float4 diff : COLOR0;		// diffuse color
				SHADOW_COORDS(1)				// data for receiving shadows
			};

			sampler2D _MainTex;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				// simple lighting
				half3 worldNormal = UnityObjectToWorldNormal(v.normal); // local space normal to world space normal
				half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));	// _WorldSpaceLightPos0 is the position (for point lights) 
																				// or direction (for directional lights)
				o.diff = nl * _LightColor0; // _LigthColor0 is the color of the lights

				// transfer shadow receiver to output data
				TRANSFER_SHADOW(o);

				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed shadow = SHADOW_ATTENUATION(i);
				col.rgb *= i.diff * shadow;	// apply lighting and shadow
				return col;
			}
			ENDCG
		}

		// Shadow Pass
		Pass
		{
			Name "ShadowCaster Pass"
			Tags { "LightMode" = "ShadowCaster" } // tells lighting engine to cast shadows
				
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				V2F_SHADOW_CASTER;		// needed data for shadow castings
			};

			v2f vert(appdata v)
			{
				v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				SHADOW_CASTER_FRAGMENT(i);
			}
			ENDCG
		}
	}
}
