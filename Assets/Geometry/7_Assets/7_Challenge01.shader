﻿Shader "CourseShaders/7_Challenge01" {
	Properties {
		_Color("Color", Color) = (1,1,1,1)
		_Normal("Normal", Color) = (1,1,1,1)
		_Emission ("Emission", Color) = (1,1,1,1)
	}

	SubShader {

		CGPROGRAM
			#pragma surface surf Lambert
			
			struct Input {
				float2 uvMainTex;
			};
			
			fixed4 _Color;
			fixed4 _Normal;
			fixed4 _Emission;
			
			void surf (Input IN, inout SurfaceOutput o) {
				o.Albedo = _Color.rgb;
				o.Normal = _Normal;
				o.Emission = _Emission.rgb;
			}
		ENDCG
	}
	FallBack "Diffuse"
}
