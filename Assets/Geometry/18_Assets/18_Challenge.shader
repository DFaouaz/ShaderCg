Shader "CourseShaders/18_Challenge"
{
    Properties{
        _MainTexture("Main Texture", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "bump" {}
        _Intensity("Normal Intensity", Range(0, 10)) = 1
        _Brightness("Brightness", Range(0, 10)) = 1
        _Scale("Texture Scale", Range(0.5, 2)) = 1
    }
    SubShader{

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTexture;
        sampler2D _NormalMap;
        half _Intensity;
        half _Brightness;
        half _Scale;

        struct Input {
            float2 uv_MainTexture;
            float2 uv_NormalMap;
        };

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_MainTexture, IN.uv_MainTexture * _Scale).rgb;

            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap * _Scale)) * _Brightness;
            o.Normal *= float3(_Intensity, _Intensity, 1.0);
        }

        ENDCG
    }
    Fallback "Diffuse"
}
