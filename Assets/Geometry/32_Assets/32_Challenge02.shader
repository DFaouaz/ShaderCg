Shader "CourseShaders/32_Challenge02"
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
        #pragma surface surf StandardSpecular // StandardSpecular lighting model

        struct Input {
            float2 uv_SpecTex;
        };
        
        float4 _Color;
        sampler2D _SpecTex;
        //fixed3 _SpecColor; // no need to declare

        void surf(Input IN, inout SurfaceOutputStandardSpecular o) {
            o.Albedo = _Color.rgb;
            o.Smoothness = 1.0 - tex2D(_SpecTex, IN.uv_SpecTex).r;
            o.Specular = _SpecColor.rgb;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
