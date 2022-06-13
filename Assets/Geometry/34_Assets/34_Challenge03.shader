Shader "CourseShaders/34_Challenge03"
{
    Properties{
        _Color("Color", Color) = (1,1,1,1)
        _RampTex("Ramp Texture", 2D) = "white" {}
    }
    SubShader{
        Tags { 
            "Queue" = "Geometry" 
        }

        CGPROGRAM
        #pragma surface surf ToonRamp

        float4 _Color;
        sampler2D _RampTex;

        half4 LightingToonRamp(SurfaceOutput o, half3 lightDir, half atten) {
            half diff = dot(o.Normal, lightDir);

            half r = diff * 0.5 + 0.5;
            half2 uv = r;
            half3 ramp = tex2D(_RampTex, uv);

            half4 c;
            c.rgb = o.Albedo * _LightColor0.rgb * ramp;
            c.a = o.Alpha;
            return c;
        }

        struct Input {
            float2 uv_ToonRamp;
            float3 viewDir;
        };
        

        void surf(Input IN, inout SurfaceOutput o) {
            half diff = dot(o.Normal, IN.viewDir);
            half r = diff * 0.5 + 0.5;
            half2 uv = r;
            half3 ramp = tex2D(_RampTex, uv);

            o.Albedo = tex2D(_RampTex, uv).rgb;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
