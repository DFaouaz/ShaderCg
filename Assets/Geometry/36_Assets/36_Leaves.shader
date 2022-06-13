Shader "CourseShaders/36_Leaves"
{
    Properties{
        _MainTex("Main Texture", 2D) = "white" {}
    }
    SubShader{
        Tags { 
            "Queue" = "Transparent" // AlphaTest and Transparent queues are valid for alpha values 
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade // alpha tag

        struct Input {
            float2 uv_MainTex;
        };
        
        sampler2D _MainTex;

        void surf(Input IN, inout SurfaceOutput o) {
            half4 color = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = color.rgb;
            o.Alpha = color.a;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
