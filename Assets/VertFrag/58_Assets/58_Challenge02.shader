Shader "CourseShaders/58_Challenge02" 
{
	Properties
	{
		_Tint("Tint Color", Color) = (1,1,1,1)
		_Speed("Speed", Range(1, 100)) = 10
		_Scale1("Scale 1", Range(0.1, 10)) = 2
		_Scale2("Scale 2", Range(0.1, 10)) = 2
		_Scale3("Scale 3", Range(0.1, 10)) = 2
		_Scale4("Scale 4", Range(0.1, 10)) = 2
	}

	SubShader
	{
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float4 _Tint;
			float _Speed;
			float _Scale1;
			float _Scale2;
			float _Scale3;
			float _Scale4;

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				const float PI = 3.14159265;
				float t = _Time.x * _Speed;

				// scale vertex values
				i.vertex.xy /= _ScreenParams.xy * i.vertex.z;

				// vertical
				float c = sin(i.vertex.x * _Scale1 + t);

				// horizontal
				c += sin(i.vertex.y * _Scale2 + t);

				// diagonal
				c += sin(_Scale3 * (i.vertex.x * sin(t / 2.0) + i.vertex.y * cos(t / 3.0)) + t);

				// circular
				float c1 = pow(i.vertex.x + 0.5 * sin(t / 5.0), 2.0);
				float c2 = pow(i.vertex.y + 0.5 * sin(t / 3.0), 2.0);
				c += sin(sqrt(_Scale4 * (c1 + c2) + 1.0 + t));

				float4 color = float4(sin(c / 4.0 * PI), sin(c / 4.0 * PI + 2 * PI / 4.0), sin(c / 4.0 * PI + PI), 1.0);
				return color;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
