// note: this uses Blinn-Phong lighting model. Blinn-Phong does have specular lighting.
Shader "CourseShaders/29_BasicBlinnPhong"
{
    Properties{
        _Color("Color", Color) = (1,1,1,1)
        _SpecColor("Specular Color", Color) = (1,1,1,1)
        _Specular("Specular Intensity", Range(0,1)) = 0.5
        _Gloss("Glossiness", Range(0,1)) = 0.5
    }
    SubShader{
        Tags { 
            "Queue" = "Geometry" 
        }

        CGPROGRAM
        #pragma surface surf BlinnPhong // lighting model goes here

        struct Input {
            float2 uv_MainTex;
        };
        
        float4 _Color;
        //float4 _SpecColor; // Unity includes this variable automatically
        half _Specular;
        fixed _Gloss;

        /*
        struct SurfaceOutput
        {
            fixed3 Albedo;  // diffuse color
            fixed3 Normal;  // tangent space normal, if written
            fixed3 Emission;
            half Specular;  // specular power in 0..1 range
            fixed Gloss;    // specular intensity
            fixed Alpha;    // alpha for transparencies
        };
        */

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo = _Color.rgb;
            o.Specular = _Specular;
            // _SpecColor is included automatically
            o.Gloss = _Gloss;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
