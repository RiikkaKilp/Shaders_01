// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tams/SpriteShadow"
{
	Properties
	{
		//[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
		_MainColor("Main Color", Color) = (1,1,1,1)
		_MaskTex("Mask Texture", 2D) = "white" {}
		_MaskReplace("Mask Replace Texture", 2D) = "white" {}
		_MaskColor("Mask Color", Color) = (1,1,1,1)
		_MaskScale("Mask Scale", vector) = (1,1,1,1)
		_Speed("Mask Texture Speed", float) = 1.0
		[MaterialToggle] PixelSnap("Pixel snap", Float) = 0
	}

		SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
			"LightMode" = "ForwardBase"
		}
	
			Cull Off
			Lighting Off
			ZWrite Off
			Blend One OneMinusSrcAlpha
	
			Pass
		{
			CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile _ PIXELSNAP_ON
		#include "AutoLight.cginc"
		#include "UnityCG.cginc"
	
		struct appdata_t
		{
			float4 vertex   : POSITION;
			float4 color    : COLOR;
			float2 texcoord : TEXCOORD0;
		};
	
		struct v2f
		{
			float4 vertex   : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord  : TEXCOORD0;
		};
	
		fixed4 _Color;
	
		v2f vert(appdata_t IN)
		{
			v2f OUT;
			OUT.vertex = UnityObjectToClipPos(IN.vertex);
			OUT.texcoord = IN.texcoord;
			OUT.color = IN.color * _Color;
			#ifdef PIXELSNAP_ON
			OUT.vertex = UnityPixelSnap(OUT.vertex);
			#endif
	
			return OUT;
		}
	
			sampler2D _MainTex;
			sampler2D _MaskTex;
			sampler2D _MaskReplace;
			float4 _MaskScale;
			float4 _MaskColor;
			float4 _MainColor;
			float _Speed;
			float4 _LightColor0;
			sampler2D _AlphaTex;
			float _AlphaSplitEnabled;
		
			fixed4 SampleSpriteTexture(float2 uv)
		{
			fixed4 color = tex2D(_MainTex, uv);
	
			#if UNITY_TEXTURE_ALPHASPLIT_ALLOWED
				if (_AlphaSplitEnabled)
					color.a = tex2D(_AlphaTex, uv).r;
			#endif //UNITY_TEXTURE_ALPHASPLIT_ALLOWED
	
			return color;
		}

		struct vertexInput
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float3 texCoord : TEXCOORD0;
		};

		struct vertexOutput
		{
			float4 pos : SV_POSITION;
			float3 normal : NORMAL;
			float3 texCoord : TEXCOORD0;
			LIGHTING_COORDS(1, 2)
		};

		vertexOutput vert(vertexInput input)
		{
			vertexOutput output;

			output.pos = UnityObjectToClipPos(input.vertex);
			output.normal = UnityObjectToWorldNormal(input.normal);

			output.texCoord = input.texCoord;

			return output;
		}

		float4 frag(vertexOutput input) : COLOR
		{
			// lighting
			float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
			float lightDot = saturate(dot(input.normal, lightDir));
			float3 lighting = lightDot * _LightColor0.rgb;
			lighting += ShadeSH9(half4(input.normal,1)); // ambient lighting

														 // albedo
			float4 albedo = tex2D(_MainTex, input.texCoord.xy);

			// mask
			float isMask = tex2D(_MaskTex, input.texCoord.xy); // == _MaskColor;

															   // screen-space coordinates
			float2 screenPos = ComputeScreenPos(input.pos).xy / _ScreenParams.xy;
			// convert to texture-space coordinates
			float2 maskPos = screenPos * _MaskScale;
			// scroll sample position
			maskPos += _Time * _Speed;

			// sample galaxy texture
			float4 mask = tex2D(_MaskReplace, maskPos);

			albedo = (1 - isMask)*(albedo + _MainColor) + isMask*mask;
			lighting = (1 - isMask)*lighting + isMask*float4(1,1,1,1);


			// final
			float3 rgb = albedo.rgb * lighting;
			return float4(rgb, 1.0);
		}
	
		fixed4 frag(v2f IN) : SV_Target
		{
			fixed4 c = SampleSpriteTexture(IN.texcoord) * IN.color;
			c.rgb *= c.a;
			return c;
		}
			ENDCG
		}
	}
}