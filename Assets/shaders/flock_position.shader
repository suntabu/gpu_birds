Shader "suntabu/flock/flockposition"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _VelocityTex ("Velocity Texture",2D) = "white" {}
        _wValue("w",Range(-10000,10000) ) = -1
    }
    SubShader
    {
       ZTest Always Cull Off ZWrite Off
       Fog { Mode off }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            
            #include "UnityCG.cginc"
 

            uniform sampler2D _MainTex;
            uniform sampler2D _VelocityTex; 
            uniform float _wValue;
            
            fixed4 frag (v2f_img i) : COLOR
            {
 
				float4 original = tex2D( _MainTex, i.uv );
				half3 actual = original.xyz * original.w ;
                
				half4 tmpV = tex2D( _VelocityTex, i.uv );
				half3 velocity = tmpV.xyz * tmpV.w;

				actual += unity_DeltaTime * velocity;
                  _wValue = 3;//length(actual);
 				actual /= _wValue;
				half4 col = half4(actual , _wValue);
				return col;
            }
            ENDCG
        }
    }
}