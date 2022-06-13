Shader "CourseShaders/51_BasicOutline"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_OutlineColor ("Outline Color", Color) = (1,1,1,1)
		_OutlineWidth ("Outline Width", Range (0, 1)) = 0.1
	}
	SubShader
	{
		Tags { "Queue"="Transparent" } // ZWrite forces this to be Transparent, otherwise, the background might render over the outline
		// First Pass - Draw outline with extruded mesh
		ZWrite Off
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		struct Input
		{
			float2 uv_MainTex;
		};

		struct appdata
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;	// surface shader is using it, it has to be named as "texcoord"
			float4 texcoord1 : TEXCOORD1;	// surface shader is using it, it has to be named as "texcoord1"
			float4 texcoord2 : TEXCOORD2;	// surface shader is using it, it has to be named as "texcoord2"
		};

		// vertex shader definition
		float4 _OutlineColor;
		float _OutlineWidth;

		void vert(inout appdata v)
		{
			v.vertex.xyz += v.normal * _OutlineWidth;
		}

		// surface shader definition
		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Emission = _OutlineColor.rgb;
		}
		ENDCG

		// Second Pass - Draw model
		ZWrite On
		CGPROGRAM
		#pragma surface surf Lambert

		struct Input 
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		fixed4 _OutlineColor;
		fixed _OutlineWidth;
		
		void surf(Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}
	Fallback "Diffuse"
}
