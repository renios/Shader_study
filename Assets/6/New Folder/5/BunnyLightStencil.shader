// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/BunnyLightStencil"
{
	Properties
	{
		_Albedo("Albedo", Color) = (1,1,1,1)
		_SpecColor("Specular Color", Color) = (1,1,1,1)
		_SpecPow("Specular Power", int) = 20
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			Stencil
			{
				Ref 0
				Comp always
				Pass keep
				Fail keep
				ZFail replace
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

			fixed4 _Albedo;
			int _SpecPow;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD0;
				float4 worldPos : TEXCOORD1;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = v.normal;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 worldNormal = normalize(mul(unity_ObjectToWorld, float4(i.normal,1)).xyz);
				half diffuse = max(0, dot(worldNormal, -_WorldSpaceLightPos0.xyz));
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
				half blinn = pow(saturate(dot(normalize(viewDirection - _WorldSpaceLightPos0.xyz), worldNormal)), _SpecPow);
				fixed4 col = _Albedo * diffuse + _SpecColor * blinn;
				// return fixed4(normalize(viewDirection),1);
				return col * _LightColor0;
			}
			ENDCG
		}
	}
}
