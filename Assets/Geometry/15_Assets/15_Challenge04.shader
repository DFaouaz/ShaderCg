Shader "CourseShaders/15_Challenge04"
{
    Properties{
        _DiffuseTexture("Difusse Texture", 2D) = "white" {}
        _EmissionTexture("Emission Texture", 2D) = "black" {}
    }
    SubShader{

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _DiffuseTexture;
        sampler2D _EmissionTexture;

        struct Input {
            float2 uv_DiffuseTexture;
            float2 uv_EmissionTexture;
        };

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_DiffuseTexture, IN.uv_DiffuseTexture).rgb;
            o.Emission = tex2D(_EmissionTexture, IN.uv_EmissionTexture).rgb;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
