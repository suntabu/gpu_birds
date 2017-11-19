Shader "suntabu/flock/flockposition"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _VelocityTex ("Velocity Texture",2D) = "white" {}
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
 
            
            fixed4 frag (v2f_img i) : COLOR
            {
            	float w = 800.0;
                float v = 10;
				float4 original = tex2D( _MainTex, i.uv );
				half3 actual = original.xyz * w - w/2;
                
				half4 tmpV = tex2D( _VelocityTex, i.uv );
				half3 velocity = tmpV.xyz * v - v/2;

				actual += unity_DeltaTime * velocity * v  + w/2  ;
 				actual /= w;
				half4 col = half4(actual , 1 );
				return col;
            }
            ENDCG
        }
    }
}