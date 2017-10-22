Shader "Unlit/Twist"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_LeftColor("Left Color", COLOR) = (1,0,0,1)
		_RightColor("Right Color", COLOR) = (0,1,0,1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

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
				fixed4 color : COLOR0;
			};

			fixed4 _LeftColor;
			fixed4 _RightColor;

			v2f vert (appdata v)
			{
				v2f o;
				o.color = lerp(_LeftColor, _RightColor, v.vertex.x * 0.5 + 0.5);
				
				float rotation = sin(_Time.w) * v.vertex.y * 0.3;
				float4x4 rotMatrix = float4x4(
					cos(rotation), 0, sin(rotation), 0,
					0, 1, 0, 0,
					-sin(rotation), 0, cos(rotation), 0,
					0, 0, 0, 1
				);
				o.vertex = UnityObjectToClipPos(mul(rotMatrix, v.vertex));
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = i.color;
				return col;
			}
			ENDCG
		}
	}
}
