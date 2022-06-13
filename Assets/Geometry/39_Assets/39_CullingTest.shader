Shader "CourseShaders/39_CullingTest" {
	Properties {
		_MainTex ("Main Texture", 2D) = "black" {}
	}
	SubShader {
		Tags { "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha 
		// Cull = not rendered
		// By default Cull Back is set
		// Cull Back | Front | Off
		Cull Off
		Pass {
			SetTexture [_MainTex] { combine texture }
		}
	}
	FallBack "Diffuse"
}
