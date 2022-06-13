Shader "CourseShaders/50_VertexExtruding"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_Extrution ("Extrude Amount", Range(-1.0, 1.0)) = 0.0
	}
	SubShader
	{
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
		float _Extrution;

		void vert(inout appdata v)
		{
			v.vertex.xyz += v.normal * _Extrution;
		}

		// surface shader definition
		sampler2D _MainTex;
		
		void surf(Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}
	Fallback "Diffuse"
}
