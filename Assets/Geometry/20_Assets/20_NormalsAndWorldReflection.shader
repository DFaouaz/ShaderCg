Shader "CourseShaders/20_NormalsAndWorldReflection"
{
    // Ilumination Models:
    // - Flat:      surface normal is not interpolated
    // - Gouraud:   vertex colors are interpolated
    // - Phong:     vertex normals are interpolated

    Properties{
        _Slider("Normal-WorldReflection Ratio", Range(0, 1)) = 0.5
    }
    SubShader{

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float3 worldRefl;   // this is how you refer to the world reflection vector
        };

        float _Slider;

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo = lerp(o.Normal, IN.worldRefl, _Slider);
        }

        ENDCG
    }
    Fallback "Diffuse"
}
