Shader "CourseShaders/38_BlendTest" {
	Properties {
		_MainTex ("Main Texture", 2D) = "black" {}
	}
	SubShader {
		Tags { "Queue" = "Transparent" }
		// Blend = src * a + dst * b
		// Blende [a] [b]
		//----------------------------
		Blend SrcAlpha OneMinusSrcAlpha // Traditional transparency
		//Blend One OneMinusSrcAlpha // Premultiplied transparency
		//Blend One One // Additive
		//Blend OneMinusDstColor One // Soft Additive
		//Blend DstColor Zero // Multiplicative
		//Blend DstColor SrcColor // 2x Multiplicative
		// 
		//---------POSSIBLE VALUES-----------
		//One					The value of this input is one.Use this to use the value of the source or the destination color.
		//Zero					The value of this input is zero.Use this to remove either the source or the destination values.
		//SrcColor				The GPU multiplies the value of this input by the source color value.
		//SrcAlpha				The GPU multiplies the value of this input by the source alpha value.
		//DstColor				The GPU multiplies the value of this input by the frame buffer source color value.
		//DstAlpha				The GPU multiplies the value of this input by the frame buffer source alpha value.
		//OneMinusSrcColor		The GPU multiplies the value of this input by(1 - source color).
		//OneMinusSrcAlpha		The GPU multiplies the value of this input by(1 - source alpha).
		//OneMinusDstColor		The GPU multiplies the value of this input by(1 - destination color).
		//OneMinusDstAlpha		The GPU multiplies the value of this input by(1 - destination alpha).

		Pass {
			SetTexture [_MainTex] { combine texture }
		}
	}
	FallBack "Diffuse"
}
