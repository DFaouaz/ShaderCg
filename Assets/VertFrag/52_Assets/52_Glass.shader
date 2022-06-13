Shader "CourseShaders/72_Glass"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NormalTex ("Normal Texure", 2D) = "bump" {}
		_BumpIntensity ("Bump Intensity", Range(0, 20)) = 1
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent"}
		GrabPass{}
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
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 uvgrab : TEXCOORD1;
				float2 uvbump : TEXCOORD2;
			};

			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;	// resolution of _GrabTexture
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _NormalTex;
			float4 _NormalTex_ST;
			float _BumpIntensity;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				// calculate uvs of grab texture
#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
#else
				float scale = 1.0;
#endif
				o.uvgrab = ComputeScreenPos(o.vertex);
				//o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y * scale) + o.vertex.w) * 0.5;		// from [-1, 1] range to [0, 1] range
				//o.uvgrab.zw = o.vertex.zw;

				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uvbump = TRANSFORM_TEX(v.uv, _NormalTex);
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target
			{
				half2 bump = UnpackNormal(tex2D(_NormalTex, i.uvbump)).rg;
				float2 offset = bump * _BumpIntensity * _GrabTexture_TexelSize.xy;
				//i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;
				i.uvgrab.xy += offset * i.uvgrab.z;

				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab)); // color from grab texture
				fixed4 tint = tex2D(_MainTex, i.uv);	// color from main texture

				col *= tint;
				return col;
			}
			ENDCG
		}
	}
}
