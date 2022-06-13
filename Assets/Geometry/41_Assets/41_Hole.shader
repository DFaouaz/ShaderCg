Shader "CourseShaders/41_Hole"
{
    Properties{
        _MainTex("Texture", 2D) = "white" {}
    }
    SubShader{
        Tags {
            "Queue" = "Geometry-1"
        }

        ZWrite Off
        ColorMask 0

        Stencil
        {
            Ref 1           // value written unto the stencil buffer
            Comp Always     // comparition operation
            Pass Replace    // what to do when comparition op. has passed
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
