Shader "Custom/42_StencilWrite" {
	Properties {
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}

		_SRef("Stencil Ref Value", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _SComp("Stencil Comp", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _SOp("Stencil Operation", Float) = 0
	}
	SubShader {
		Tags { "RenderType"="Geometry-1" }

		ZWrite Off
		ColorMask 0

		Stencil{
			Ref [_SRef]
			Comp [_SComp]
			Pass [_SOp]
		}
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _NormalMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
		}
		ENDCG
	}
	FallBack "Diffuse"
}
