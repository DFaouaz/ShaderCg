Shader "CourseShaders/22_Challenge"
{
    Properties{
        _NormalMap("Normal Map", 2D) = "bump" {}
        _CubeMap("Cube Map", CUBE) = "white" {}
    }
    SubShader{

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _NormalMap;
        samplerCUBE _CubeMap;

        struct Input {
            float2 uv_NormalMap;
            float3 worldRefl; INTERNAL_DATA
        };

        void surf(Input IN, inout SurfaceOutput o) {
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap)) * 0.3; // the order matters
            o.Albedo = texCUBE(_CubeMap, WorldReflectionVector(IN, o.Normal) ).rgb;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
