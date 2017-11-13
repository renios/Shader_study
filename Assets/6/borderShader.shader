// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/borderShader"
{
	Properties
	{
		_Scale("Scale", FLOAT) = 0
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		Stencil
		{
			Ref 3
			ReadMask 255
			WriteMask 255
			Comp equal
			Pass keep
			Fail keep
			ZFail keep
		}

		Pass
		{
			Ztest always
			Zwrite off
			Cull Front

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			float _Scale;
			
			v2f vert (appdata v)
			{
				v2f o;
				float4 scaledpos = v.vertex + float4(v.normal * _Scale,0);
				float4 worldpos = mul(unity_ObjectToWorld, scaledpos);
				float4 viewpos = mul(UNITY_MATRIX_V, worldpos);
				float4 clippos = mul(UNITY_MATRIX_P, viewpos);
				o.vertex = clippos;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = fixed4(1,0,0,1);
				return col;
			}
			ENDCG
		}
	}
}
