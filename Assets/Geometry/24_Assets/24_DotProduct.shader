Shader "CourseShaders/24_DotProduct"
{
    Properties{
    }
    SubShader{

        CGPROGRAM
        #pragma surface surf Lambert

        // Having vector a and b, dot product is calculated:
        // - a·b = ax*bx + ay*by + az*bz
        // - a·b = |a|*|b|*cos(angle)
        // It returns a decimal number
        // If a and b have the same direction = +1
        // If a and b have the opposite direction = -1
        // If a and b are perpendicular(90 degrees) = 0

        struct Input {
            float3 viewDir; // direction from surface to the viewer
        };

        void surf(Input IN, inout SurfaceOutput o) {
            half dotP = dot(IN.viewDir, o.Normal);
            o.Albedo = dotP;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
