Shader "CourseShaders/25_Rim"
{
    Properties{
        _RimColor("Rim Color", Color) = (1, 1, 1, 1)
        _RimPower("Rim Power", Range(0, 10)) = 1
    }
    SubShader{

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float3 viewDir;
        };
        
        float4 _RimColor;
        float _RimPower;

        void surf(Input IN, inout SurfaceOutput o) {
            // use normalize(v) to get a normalized vector from 'v' (magnitude of 1, same direction)
            // use saturate(a) to clamp 'a' value from 0 to 1
            // use pow(a,b) to get 'a' raised to the power of 'b'

            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow(rim, _RimPower);
        }

        ENDCG
    }
    Fallback "Diffuse"
}
