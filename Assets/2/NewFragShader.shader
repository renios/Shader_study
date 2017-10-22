Shader "SNUGDC/MyFragmentShader"
{
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
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float deltaX = _CosTime.w/4 + 0.5;
				float deltaY = _SinTime.w/4 + 0.5;
				fixed4 col_circle = fixed4((i.uv.x-deltaX) * (i.uv.x-deltaX) + 
									(i.uv.y-deltaY) * (i.uv.y-deltaY) < 0.01, 0, 0, 1);
				
				fixed4 col_cross = fixed4(0, (i.uv.x > 0.2 && i.uv.x < 0.4) || (i.uv.y > 0.2 && i.uv.y < 0.4), 0, 0);


				fixed4 col = col_circle + col_cross;

				return col;
			}
			ENDCG
		}
	}
}
