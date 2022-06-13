Shader "CourseShaders/33_CustomBasicLambert"
{
    Properties{
        _Color("Color", Color) = (1,1,1,1)
    }
    SubShader{
        Tags { 
            "Queue" = "Geometry" 
        }

        CGPROGRAM
        #pragma surface surf BasicLambert // name of the model

        // Lighting model function has to have "Lighting" prefix followed by the name of the model
        // Args are surface data, light direction and attenuation
        // return a half4 color with "applied lighting effect"
        half4 LightingBasicLambert(SurfaceOutput o, half3 lightDir, half atten) {
            half NdotL = dot(o.Normal, lightDir);
            half4 c;
            // "_LightColor0" is the color of all of the scene lights that are affecting the model
            c.rgb = o.Albedo * _LightColor0.rgb * (NdotL * atten);
            c.a = o.Alpha;
            return c;
        }

        struct Input {
            float2 uv_MainTex;
        };
        
        float4 _Color;

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo = _Color.rgb;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
