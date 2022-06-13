Shader "CourseShaders/51_AdvanceOutline"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
		_OutlineColor("Outline Color", Color) = (1,1,1,1)
		_OutlineWidth("Outline Width", Range(0, 1)) = 0.1
	}
	SubShader
	{
		CGPROGRAM
		#pragma surface surf Lambert

		struct Input
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		fixed4 _OutlineColor;
		fixed _OutlineWidth;

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG

		Pass
		{
			Name "Outline Pass"

			Cull Front // discard front faces

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				fixed4 color : COLOR;
			};

			float _OutlineWidth;
			float4 _OutlineColor;

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				
				float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal)); // transform local space normal into view space normal
				float2 offset = TransformViewToProjection(norm.xy);	// transform view space normal into projection(clip) space normal

				o.pos.xy += offset * o.pos.z * _OutlineWidth;	// apply outline
				o.color = _OutlineColor;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return i.color;
			}

			ENDCG
		}
	}
	Fallback "Diffuse"
}
