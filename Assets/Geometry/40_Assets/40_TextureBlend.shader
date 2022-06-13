Shader "CourseShaders/40_TextureBlend" {
	Properties {
		_MainTex("Main Texture", 2D) = "white" {}
		_DecalTex ("Decal Texture", 2D) = "white" {}
        [Toggle] _ShowDecal("Show Decal ?", Float) = 0.0
	}
	SubShader {
		Tags { "Queue" = "Geometry" }
        
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _DecalTex;
        half _ShowDecal;

        struct Input {
            float2 uv_MainTex;
            //float2 uv_DecalTex; // not needed cause we can reuse _MainTex UVs
        };


        void surf(Input IN, inout SurfaceOutput o) {
            float4 color = tex2D(_MainTex, IN.uv_MainTex);
            float4 decal = tex2D(_DecalTex, IN.uv_MainTex) * _ShowDecal;

            //o.Albedo = color.rgb * decal.rgb; // multiplicative
            //o.Albedo = color.rgb + decal.rgb; // additive
            o.Albedo = decal.r > 0.9 ? decal.rgb : color.rgb;

        }

        ENDCG
    }
    Fallback "Diffuse"
}
