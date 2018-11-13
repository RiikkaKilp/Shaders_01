// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


// TO DO:
// Mask texture tiling and offset
Shader "Tams/ColorReplace"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MaskTex("Mask Texture", 2D) = "white" {}
		_MaskColor("Mask Color", Color) = (1,1,1,1)
		_ReplaceColor("Replace Color", Color) = (1,0,1,1)
		_MaskScale("Mask Scale", Float) = 1
		_Diff("Tolerance", Float) = 0.05
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
			float4		_MainTexure_ST;
			float4		_MaskTex_ST;
			sampler2D	_MaskTex;
			float4		_MaskColor;
			float4		_ReplaceColor;
			float		_MaskScale;
			float		_Diff;

			v2f vert (appdata v)
			{
				v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);

				// These two lines are copypaste from somewhere, and I'm not sure how necessary they are.
				// Note: not necessary at all, it seems.

				// Gets the xy position of the vertex in worldspace.
					float2 worldXY = mul(unity_ObjectToWorld, v.vertex).xy;
				// Use the worldspace coords instead of the mesh's UVs.
					o.uv = TRANSFORM_TEX(worldXY, _MaskTex);

				//v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				// Without this --v the image will be upside down
				o.uv = v.uv;
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
			
				if (col.r > _MaskColor.r - _Diff && col.r < _MaskColor.r + _Diff &&
					col.g > _MaskColor.g - _Diff && col.g < _MaskColor.g + _Diff &&
					col.b > _MaskColor.b - _Diff && col.b < _MaskColor.b + _Diff)
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
