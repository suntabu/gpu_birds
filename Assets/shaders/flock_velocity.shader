Shader "suntabu/flock/flockvelocity"
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


            uniform float time;
			uniform float testing;
			uniform float seperationDistance; // 20
			uniform float alignmentDistance; // 40
			uniform float cohesionDistance; //
			uniform float freedomFactor;
			uniform half3 predator;
			const float PI = 3.141592653589793;
			const float PI_2 = 6.28318530717;
			// const float VISION = PI * 0.55;
			float zoneRadius = 40.0;
			float zoneRadiusSquared = 1600.0;
			float separationThresh = 0.45;
			float alignmentThresh = 0.65;
			const float UPPER_BOUNDS = 400;
			const float LOWER_BOUNDS = -400;
			const float SPEED_LIMIT = 9.0;

			const float width = 128;
			const float height = 128;

			float rand(half2 co){
				return frac(sin(dot(co.xy ,half2(12.9898,78.233))) * 43758.5453);
			}

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _PositionTex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
				zoneRadius = seperationDistance + alignmentDistance + cohesionDistance;
				separationThresh = seperationDistance / zoneRadius;
				alignmentThresh = ( seperationDistance + alignmentDistance ) / zoneRadius;
				zoneRadiusSquared = zoneRadius * zoneRadius;
				half3 birdPosition, birdVelocity;
				half3 selfPosition = tex2D( _PositionTex, i.uv ).xyz;
				half3 selfVelocity = tex2D( _VelocityTex, i.uv ).xyz;
				float dist;
				half3 dir; // direction
				float distSquared;
				float seperationSquared = seperationDistance * seperationDistance;
				float cohesionSquared = cohesionDistance * cohesionDistance;
				float f;
				float percent;
				half3 velocity = selfVelocity;
				float limit = SPEED_LIMIT;
				dir = predator * UPPER_BOUNDS - selfPosition;
				dir.z = 0.;
				// dir.z *= 0.6;
				dist = length( dir );
				distSquared = dist * dist;
				float preyRadius = 150.0;
				float preyRadiusSq = preyRadius * preyRadius;
				// move birds away from predator
				if (dist < preyRadius) {
					f = ( distSquared / preyRadiusSq - 1.0 ) * unity_DeltaTime * 100.;
					velocity += normalize( dir ) * f;
					limit += 5.0;
				}
				// if (testing == 0.0) {}
				// if ( rand( uv + time ) < freedomFactor ) {}
				// Attract flocks to the center
				half3 central = half3( 0., 0., 0. );
				dir = selfPosition - central;
				dist = length( dir );
				dir.y *= 2.5;
				velocity -= normalize( dir ) * unity_DeltaTime * 5.;
 
				birdPosition = tex2D( _PositionTex, i.uv ).xyz;
				dir = birdPosition - selfPosition;
				dist = length(dir);
				if (dist > 0.0001) {
					distSquared = dist * dist;
					if (distSquared <= zoneRadiusSquared ) {
						percent = distSquared / zoneRadiusSquared;
						if ( percent < separationThresh ) { // low
							// Separation - Move apart for comfort
							f = (separationThresh / percent - 1.0) * unity_DeltaTime;
							velocity -= normalize(dir) * f;
						} else if ( percent < alignmentThresh ) { // high
							// Alignment - fly the same direction
							float threshunity_DeltaTime = alignmentThresh - separationThresh;
							float adjustedPercent = ( percent - separationThresh ) / threshunity_DeltaTime;
							birdVelocity = tex2D( _VelocityTex, i.uv ).xyz;
							f = ( 0.5 - cos( adjustedPercent * PI_2 ) * 0.5 + 0.5 ) * unity_DeltaTime;
							velocity += normalize(birdVelocity) * f;
						} else {
							// Attraction / Cohesion - move closer
							float threshunity_DeltaTime = 1.0 - alignmentThresh;
							float adjustedPercent = ( percent - alignmentThresh ) / threshunity_DeltaTime;
							f = ( 0.5 - ( cos( adjustedPercent * PI_2 ) * -0.5 + 0.5 ) ) * unity_DeltaTime;
							velocity += normalize(dir) * f;
						}
					}
				}
				// this make tends to fly around than down or up
				// if (velocity.y > 0.) velocity.y *= (1. - 0.2 * unity_DeltaTime);
				// Speed Limits
				if ( length( velocity ) > limit ) {
					velocity = normalize( velocity ) * limit;
				}
				half4 col = half4( velocity, 1.0 );
				return col;
            }
            ENDCG
        }
    }
}