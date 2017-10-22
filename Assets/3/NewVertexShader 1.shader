// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/NewVertexShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

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
				float4 color : COLOR0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{	
				v2f o;

				float t = _Time.y * v.vertex.y;
				float4x4 rotMat = float4x4 (
					cos(t), 0, sin(t), 0,
					0, 1, 0, 0,
					-sin(t), 0, cos(t), 0,
					0, 0, 0, 1
				);

				o.color = lerp(float4(1,0,0,1), float4(0,1,0,1), v.vertex.x);
				o.color.b = lerp(0, 1, v.vertex.y);

				float4 worldpos = mul(unity_ObjectToWorld, mul(rotMat, v.vertex));
				float4 viewpos = mul(UNITY_MATRIX_V, worldpos);
				float4 clippos = mul(UNITY_MATRIX_P, viewpos);
				o.vertex = clippos;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv) * i.color;
				return col;
			}
			ENDCG
		}
	}
}
