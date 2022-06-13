Shader "CourseShaders/45_GrabPassVF"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_ScaleUVX ("Scale UV X", Range(0.2, 10)) = 1
		_ScaleUVY ("Scale UV Y", Range(0.2, 10)) = 1
	}
	SubShader
	{
		Tags { "Queue"="Transparent" }	// avoid recursive rendering of _GrabTexture

		GrabPass {} // takes a "screenshot" of the framebuffer and put it in _GrabTexture
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _GrabTexture; // screen capture from previour GrabPass
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _ScaleUVX;
			float _ScaleUVY;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				// UVs modifications
				o.uv.x = sin(o.uv.x * _ScaleUVX);
				o.uv.y = sin(o.uv.y * _ScaleUVY);

				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_GrabTexture, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
