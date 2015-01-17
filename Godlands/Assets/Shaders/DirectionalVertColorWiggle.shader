Shader "Custom/DirectionalVertColorWiggle" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		// LIGHTING STUFF
		_LightColor ("Light Color", Color) = (1, 1, 1, 1)
		_DimColor ("Dim Color", Color) = (0, 0, 0, 1)
		_ColorDir ("LightDirection", Vector) = (0, 0, 0, 0)
		_Lerp ("Lerp Value", Range(0, 1)) = 0.5
		
		// WIGGLE STUFF
		_WiggleSpeed ("Wiggle Speed", Float) = 0
		_WiggleDist ("Vert Dist", Float) = 0.012
		
		_CurWiggleStrength ("Wiggle Force", Float) = 0

		_MaxWigglePos ("Desired Wiggle Source", Vector) = (0, 0, 0, 0)
		_CurWigglePos ("Current Wiggle Source", Vector) = (0, 0, 0, 0)
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque"}
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert addshadow

		sampler2D _MainTex;
		float4 _MainColor;
		
		// LIGHTING STUFF
		float4 _LightColor;
		float4 _DimColor;
		float4 _ColorDir;
		float _Lerp;
		
		// WIGGLE STUFF
		float _WiggleSpeed;
		float _WiggleDist;
		
		float _CurWiggleStrength;
		
		float4 _MaxWigglePos;
		float4 _CurWigglePos;

		struct Input 
		{
			float3 worldNormal;
			float3 color:COLOR;
		
			float2 uv_MainTex;
			float3 worldPos;
		};

		void vert (inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);
			o.worldPos = mul(_Object2World, v.vertex);

			float3 dirToVert = normalize(o.worldPos - _MaxWigglePos);
			float distMod = _WiggleDist - clamp(length(_MaxWigglePos - o.worldPos), 0, _WiggleDist);
			float appliedWiggleStrength = sin(_WiggleSpeed * _Time.y);
			
			v.vertex.xyz += dirToVert * _CurWiggleStrength * distMod * appliedWiggleStrength;
		}
		
		void surf (Input IN, inout SurfaceOutput o) 
		{
			float4 litColor = lerp(_DimColor, _LightColor, (dot(IN.worldNormal, normalize(_ColorDir.xyz)) * 0.5) + 0.5);
			o.Albedo = lerp(IN.color, litColor.rgb, _Lerp);
			o.Alpha = litColor.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
