Shader "Tams/NoiceOffset"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
		_NoiseTex("Noise Texture", 2D) = "white" {}
	}
		SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 100

			Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
					float2 noiseuv : TEXCOORD1;
				};

			struct v2f
				{
					float2 uv : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				sampler2D _NoiseTex;
				float4 _MainTex_ST;


		//		// pixel shader / fragment shader
		//		fixed4 frag(v2f i) : SV_Target
		//		{
		//			// sample the texture
		//			fixed4 col = tex2D(_MainTex, i.uv);
		//			// apply fog
		//			UNITY_APPLY_FOG(i.fogCoord, col);
		//			return col;
		//
		//			// sample the texture
		//			fixed4 color = tex2D(_NoiseTex, i.uv);
		//			float height = (color.r * color.b * color.g) / 3;
		//
		//			// apply fog
		//			UNITY_APPLY_FOG(i.fogCoord, col);
		//
		//			return height;
		//		}

					// vertex shader
				v2f vert(appdata v)
				{
					v2f o;

					v.vertex.y += sin(v.vertex.x + _Time.y) * .3;
					//screen cord / world to screenspace / vert position
					o.vertex = UnityObjectToClipPos(v.vertex);
					// passing along the uv coord
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				// pixel shader / fragment shader
				fixed4 frag(v2f i) : SV_Target
				{
					// sample the texture
					fixed4 col = tex2D(_MainTex, i.uv + sin(3 + _Time.y) * .2);
					// apply fog
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}

			ENDCG
		}
	}
}
