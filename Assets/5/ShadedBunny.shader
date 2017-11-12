// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/ShadedBunny"
{
	Properties
	{
		_SpecPow("Specular Power", int) = 20
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Tags { "LightMode"="ForwardBase" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"
			
			int _SpecPow;

			struct appdata // Vertex shader 입력값
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
			};

			struct v2f // Vertex -> Fragmane Interpolator
			{
				float4 vertex : SV_POSITION;
				float4 worldNormal : TEXCOORD0;
				float4 modelNormal : TEXCOORD1;
				float4 worldPosition : TEXCOORD2;
				float4 ambient : TEXCOORD3;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldNormal = (mul(unity_ObjectToWorld, v.normal));
				o.modelNormal = v.normal;
				o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
				o.ambient = fixed4(ShadeSH9(o.worldNormal),1);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = fixed4(1,0,0,1);
				fixed3 diff = saturate(-dot(_WorldSpaceLightPos0, i.worldNormal));
				float3 camDirection = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition.xyz);
				float3 reflectDirection = _WorldSpaceLightPos0.xyz - (dot(i.worldNormal, _WorldSpaceLightPos0) * 2) * i.worldNormal;
				float spec = pow(saturate(dot(reflectDirection, camDirection)), _SpecPow);
				float4 ambient = fixed4(ShadeSH9(i.worldNormal), 1);

				// return pow(dot(reflectDirection, camDirection), _SpecPow);
				// return i.worldNormal;
				// return i.modelNormal;
				return col * (fixed4(diff, 1) * _LightColor0 + ambient) 
						+ fixed4(spec, spec, spec, 1) * _LightColor0;
			}
			ENDCG
		}
	}
}
