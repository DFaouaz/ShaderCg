Shader "CourseShaders/33_CustomBasicBlinnPhong"
{
    Properties{
        _Color("Color", Color) = (1,1,1,1)
    }
    SubShader{
        Tags { 
            "Queue" = "Geometry" 
        }

        CGPROGRAM
        #pragma surface surf BasicBlinnPhong // name of the model

        // Lighting model function has to have "Lighting" prefix followed by the name of the model
        // Args are surface data, light direction, view direction and attenuation
        // return a half4 color with "applied lighting effect"
        half4 LightingBasicBlinnPhong(SurfaceOutput o, half3 lightDir, half3 viewDir, half atten) {
            half3 h = normalize(lightDir + viewDir); // halfway vector

            half diff = saturate(dot(o.Normal, lightDir)); // diffuse
            //half diff = max(0, dot(o.Normal, lightDir)); // diffuse alternative
            
            float nh = max(0, dot(o.Normal, h)); // specular falloff
            float spec = pow(nh, 48.0); // "48" is Unity's default

            // "_LightColor0" is the color of all of the scene lights that are affecting the model
            half4 c;
            c.rgb = (o.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
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
