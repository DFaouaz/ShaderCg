Shader "CourseShaders/30_StandardSpecPBR"
{
    Properties{
        _Color("Color", Color) = (1,1,1,1)
        _SpecTex("Specular Texture", 2D) = "white" {}
        _SpecColor("Specular Color", Color) = (1,1,1,1)
    }
    SubShader{
        Tags { 
            "Queue" = "Geometry" 
        }

        CGPROGRAM
        #pragma surface surf StandardSpecular // StandardSpeculat lighting model

        struct Input {
            float2 uv_SpecTex;
        };
        
        float4 _Color;
        sampler2D _SpecTex;
        //fixed3 _SpecColor; // no need to declare

        /*
        struct SurfaceOutputStandardSpecular
        {
            fixed3 Albedo;      // diffuse color
            fixed3 Specular;    // specular color
            fixed3 Normal;      // tangent space normal, if written
            half3 Emission;
            half Smoothness;    // 0=rough, 1=smooth
            half Occlusion;     // occlusion (default 1)
            fixed Alpha;        // alpha for transparencies
        };
        */

        void surf(Input IN, inout SurfaceOutputStandardSpecular o) {    // note how the output struct name is different to the Non-PBR shaders (SurfaceOutput)
            o.Albedo = _Color.rgb;
            o.Smoothness = tex2D(_SpecTex, IN.uv_SpecTex).r;
            o.Specular = _SpecColor.rgb;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
