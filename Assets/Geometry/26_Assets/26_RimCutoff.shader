Shader "CourseShaders/26_RimCutoff"
{
    Properties{
        _RimPower("Rim Power", Range(0, 10)) = 1
        _Cutoff("Cutoff", Range(0, 1)) = 0.4
        _WorldScale("World Scale", Float) = 1
    }
    SubShader{

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float3 viewDir;
            float3 worldPos; // world position of the pixel
        };
        
        float _RimPower;
        float _Cutoff;
        float _WorldScale;

        void surf(Input IN, inout SurfaceOutput o) {

            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            rim = pow(rim, _RimPower);
            
            // use frac(d) to get the decimal part of a decimal number
            o.Emission = (frac(IN.worldPos.y * _WorldScale * _Cutoff) > _Cutoff ? float3(0, 1, 0) : float3(1, 0, 0)) * rim;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
