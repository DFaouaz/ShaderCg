Shader "CourseShaders/41_Wall"
{
    Properties{
        _MainTex("Texture", 2D) = "white" {}
    }
    SubShader{
        Tags {
            "Queue" = "Geometry"
        }

        Stencil
        {
            Ref 1           // value written unto the stencil buffer
            Comp NotEqual     // comparition operation
            Pass Keep       // what to do when comparition op. has passed
        }

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uv_MainTex;
        };
        
        sampler2D _MainTex;

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
