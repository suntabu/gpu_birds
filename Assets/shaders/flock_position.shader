Shader "suntabu/flock/flockposition"
{
    Properties
    {
        _PositionTex ("Position Texture", 2D) = "white" {}
        _VelocityTex ("Velocity Texture",2D) = "white" {}
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
            // make fog work
            #pragma multi_compile_fog
            
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

            sampler2D _PositionTex;
            sampler2D _VelocityTex;
            float4 _PositionTex_ST;
            float4 _VelocityTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _PositionTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
				half4 tmpPos = tex2D( _PositionTex, i.uv );
				half3 position = tmpPos.xyz;
				half3 velocity = tex2D( _VelocityTex, i.uv ).xyz;
				float phase = tmpPos.w;
				phase = fmod( ( phase + unity_DeltaTime +
					length( velocity.xz ) * unity_DeltaTime * 3. +
					max( velocity.y, 0.0 ) * unity_DeltaTime * 6. ), 62.83 );
				half4 col = half4( position + velocity * unity_DeltaTime * 15. , phase );
				return col;
            }
            ENDCG
        }
    }
}