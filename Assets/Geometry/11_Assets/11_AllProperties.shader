Shader "CourseShaders/11_AllProperties"
{
    Properties{
        _Color("Color", Color) = (1,1,1,1)
        _Range("Range", Range(0,5)) = 1
        _Texture("Texture", 2D) = "white" {}
        _Cube("Cube", CUBE) = "" {}
        _Float("Float", Float) = 0.5
        _Vector("Vector", Vector) = (0.5,1,1,1)
    }
    SubShader{

        CGPROGRAM
        #pragma surface surf Lambert

        fixed4 _Color;
        half _Range;
        sampler2D _Texture;
        samplerCUBE _Cube;
        float _Float;
        float4 _Vector;

        struct Input {
            float2 uv_Texture;
            float3 worldRefl;
        };

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo = (tex2D(_Texture, IN.uv_Texture) * _Range).rgb;
            o.Emission = texCUBE(_Cube, IN.worldRefl).rgb;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
