Shader "CourseShaders/17_NormalMapping"
{
    Properties{
        _MainTexture("Main Texture", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "bump" {} // note the default value is bump
        _Intensity("Normal Intensity", Range(0, 10)) = 1
    }
    SubShader{

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTexture;
        sampler2D _NormalMap;
        half _Intensity;

        struct Input {
            float2 uv_MainTexture;
            float2 uv_NormalMap;
        };

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_MainTexture, IN.uv_MainTexture).rgb;

            // Normal mapping:
            // R: 0 to 255 -> x: -1 to +1
            // G: 0 to 255 -> x: -1 to +1
            // B: 0 to 255 -> x:  0 to -1
            // Use UnpackNormal(*rgb_color_value*) or map manually

            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap)).rgb;
            o.Normal *= float3(_Intensity, _Intensity, 1.0); // modify only x and y axis to increase the intensity of the normal
        }

        ENDCG
    }
    Fallback "Diffuse"
}
