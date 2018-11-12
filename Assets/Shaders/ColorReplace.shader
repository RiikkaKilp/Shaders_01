// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tams/ColorReplace"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MaskTex("Mask Texture", 2D) = "white" {}
		_MaskColor("Mask Color", Color) = (1,1,1,1)
		_ReplaceColor("Replace Color", Color) = (1,0,1,1)
		_MaskScale("Mask Scale", Float) = 1
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};


			sampler2D	_MainTex;
			float4		_MaskTex_ST;
			sampler2D	_MaskTex;
			float4		_MaskColor;
			float4		_ReplaceColor;
			float		_MaskScale;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				// Gets the xy position of the vertex in worldspace.
				float2 worldXY = mul(unity_ObjectToWorld, v.vertex).xy;
				// Use the worldspace coords instead of the mesh's UVs.
				o.uv = TRANSFORM_TEX(worldXY, _MaskTex);

				//v2f o;
				//o.vertex = UnityObjectToClipPos(v.vertex);
				//o.uv = v.uv;
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float diff = 0.05;

				fixed4 col = tex2D(_MainTex, i.uv);
			
				if (col.r > _MaskColor.r - diff && col.r < _MaskColor.r + diff &&
					col.g > _MaskColor.g - diff && col.g < _MaskColor.g + diff &&
					col.b > _MaskColor.b - diff && col.b < _MaskColor.b + diff)
				{
					col = tex2D(_MaskTex, i.uv * _MaskScale);
					col.rgb *= _ReplaceColor;
					//col.r = _ReplaceColor.r;
					//col.g = _ReplaceColor.g;
					//col.b = _ReplaceColor.b;
				}

			//	if (col.r == _MaskColor.r && col.g == _MaskColor.g && col.b == _MaskColor.b)
			//	{
			//		col.r = _ReplaceColor.r;
			//		col.g = _ReplaceColor.g;
			//		col.b = _ReplaceColor.b;
			//	}

				return col;
			}
			ENDCG
		}
	}
}
