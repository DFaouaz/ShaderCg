Shader "CourseShaders/37_Hologram"
{
    Properties{
        _RimColor("Rim Color", Color) = (1, 1, 1, 1)
        _RimPower("Rim Power", Range(0, 10)) = 1
    }
    SubShader{
        Tags {
            "Queue" = "Transparent"
        }

        Pass {
            ZWrite On       // write unto de Z-Buffer
            ColorMask 0     // write no color in the frame buffer
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        struct Input {
            float3 viewDir;
        };
        
        float4 _RimColor;
        float _RimPower;

        void surf(Input IN, inout SurfaceOutput o) {
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow(rim, _RimPower);
            o.Alpha = pow(rim, _RimPower);
        }

        ENDCG
    }
    Fallback "Diffuse"
}
