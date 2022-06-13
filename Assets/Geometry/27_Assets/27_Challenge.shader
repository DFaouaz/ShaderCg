Shader "CourseShaders/27_Challenge"
{
    Properties{
        _DiffuseTex("Diffuse Texture", 2D) = "white" {}
        _RimPower("Rim Power", Range(0, 10)) = 1
        _StripeWidth("Stripe Width", Range(0.01, 2)) = 0.02
    }
    SubShader{

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uv_DiffuseTex;
            float3 viewDir;
            float3 worldPos; // world position of the pixel
        };
        
        sampler2D _DiffuseTex;
        float _RimPower;
        float _StripeWidth;

        void surf(Input IN, inout SurfaceOutput o) {
            // set diffuse
            o.Albedo = tex2D(_DiffuseTex, IN.uv_DiffuseTex).rgb;

            // set emission with rim
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            rim = pow(rim, _RimPower);
            
            // use frac(d) to get the decimal part of a decimal number
            o.Emission = (frac(IN.worldPos.y / _StripeWidth * 0.5) > 0.5 ? float3(0, 1, 0) : float3(1, 0, 0)) * rim;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
