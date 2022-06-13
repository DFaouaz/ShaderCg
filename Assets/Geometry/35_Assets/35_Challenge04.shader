Shader "CourseShaders/35_Challenge04"
{
    Properties{
        _Color("Color", Color) = (1,1,1,1)
    }
    SubShader{
        Tags { 
            "Queue" = "Geometry" 
        }

        CGPROGRAM
        #pragma surface surf BasicBlinnPhong

        half4 LightingBasicBlinnPhong(SurfaceOutput o, half3 lightDir, half3 viewDir, half atten) {
            half3 h = normalize(lightDir + viewDir); // halfway vector

            half diff = max(0, dot(o.Normal, lightDir)); // diffuse alternative
            
            float nh = max(0, dot(o.Normal, h)); // specular falloff
            float spec = pow(nh, 48.0); // "48" is Unity's default

            half4 c;
            c.rgb = (o.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten * _SinTime; // sin(_Time)
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
