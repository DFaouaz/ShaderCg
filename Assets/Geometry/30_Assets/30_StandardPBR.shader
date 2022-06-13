Shader "CourseShaders/30_StandardPBR"
{
    Properties{
        _Color("Color", Color) = (1,1,1,1)
        _MetallicTex("Metallic Texture", 2D) = "white" {}
        _Metallic("Metallic", Range(0,1)) = 0.5
    }
    SubShader{
        Tags { 
            "Queue" = "Geometry" 
        }

        CGPROGRAM
        #pragma surface surf Standard // Standard lighting model

        struct Input {
            float2 uv_MetallicTex;
        };
        
        float4 _Color;
        sampler2D _MetallicTex;
        half _Metallic;

        /*
        struct SurfaceOutputStandard
        {
            fixed3 Albedo;      // base (diffuse or specular) color
            fixed3 Normal;      // tangent space normal, if written
            half3 Emission;
            half Metallic;      // 0=non-metal, 1=metal
            half Smoothness;    // 0=rough, 1=smooth
            half Occlusion;     // occlusion (default 1)
            fixed Alpha;        // alpha for transparencies
        };
        */

        void surf(Input IN, inout SurfaceOutputStandard o) {    // note how the output struct name is different to the Non-PBR shaders (SurfaceOutput)
            o.Albedo = _Color.rgb;
            o.Smoothness = tex2D(_MetallicTex, IN.uv_MetallicTex).r;
            o.Metallic = _Metallic;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
