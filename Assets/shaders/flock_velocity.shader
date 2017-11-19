Shader "suntabu/flock/flockvelocity"
{
    Properties
    {
        _PositionTex ("Position Texture", 2D) = "white" {}
        _MainTex ("Main Texture",2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            
            #include "UnityCG.cginc"

           

            sampler2D _PositionTex;
            sampler2D _MainTex;
            

            uniform float time;
			uniform float testing;
            uniform float delta =0.016; // about 0.016
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

			const float width = 8;
			const float height = 8;

			float rand(half2 co){
				return frac(sin(dot(co.xy ,half2(12.9898,78.233))) * 43758.5453);
			}

           
            
            fixed4 frag (v2f_img i) : COLOR
            {
            	float w = 800;
            	float v = 10;
            	
	            zoneRadius = seperationDistance + alignmentDistance + cohesionDistance;
                separationThresh = seperationDistance / zoneRadius;
                alignmentThresh = ( seperationDistance + alignmentDistance ) / zoneRadius;
                zoneRadiusSquared = zoneRadius * zoneRadius;
                fixed2 uv = i.uv;
                fixed3 birdPosition, birdVelocity;
                fixed3 selfPosition = tex2D( _PositionTex, uv ).xyz;

                selfPosition *= w;
                selfPosition -= w/2;


                fixed3 selfVelocity = tex2D( _PositionTex, uv ).xyz;

                selfVelocity *= v;
                selfVelocity -=v/2;

                float dist;
                fixed3 dir; // direction
                float distSquared;
                float seperationSquared = seperationDistance * seperationDistance;
                float cohesionSquared = cohesionDistance * cohesionDistance;
                float f;
                float percent;
                fixed3 velocity = selfVelocity;
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
                    f = ( distSquared / preyRadiusSq - 1.0 ) * delta * 100.;
                    velocity += normalize( dir ) * f;
                    limit += 5.0;
                }
                // if (testing == 0.0) {}
                // if ( rand( uv + time ) < freedomFactor ) {}
                // Attract flocks to the center
                fixed3 central = fixed3( 0., 0., 0. );
                dir = selfPosition - central;
                dist = length( dir );
                dir.y *= 2.5;
                velocity -= normalize( dir ) * delta * 5.;
                for (float y=0.0;y < height;y++) {
                    for (float x=0.0;x<width;x++) {
                        fixed2 ref = fixed2( x + 0.5,y + 0.5 ) /fixed2(width,height) ;
                        birdPosition = tex2D( _PositionTex, ref ).xyz;
                        dir = birdPosition - selfPosition;
                        dist = length(dir);
                        if (dist >= 0.0001)  {
                            distSquared = dist * dist;
                            if (distSquared <= zoneRadiusSquared ) {
                            percent = distSquared / zoneRadiusSquared;
                                if ( percent < separationThresh ) { // low
                                    // Separation - Move apart for comfort
                                    f = (separationThresh / percent - 1.0) * delta;
                                    velocity -= normalize(dir) * f;
                                } else if ( percent < alignmentThresh ) { // high
                                    // Alignment - fly the same direction
                                    float threshDelta = alignmentThresh - separationThresh;
                                    float adjustedPercent = ( percent - separationThresh ) / threshDelta;
                                    birdVelocity = tex2D( _PositionTex, ref ).xyz;
                                    f = ( 0.5 - cos( adjustedPercent * PI_2 ) * 0.5 + 0.5 ) * delta;
                                    velocity += normalize(birdVelocity) * f;
                                } else {
                                    // Attraction / Cohesion - move closer
                                    float threshDelta = 1.0 - alignmentThresh;
                                    float adjustedPercent = ( percent - alignmentThresh ) / threshDelta;
                                    f = ( 0.5 - ( cos( adjustedPercent * PI_2 ) * -0.5 + 0.5 ) ) * delta;
                                    velocity += normalize(dir) * f;
                                }
                            }
                       }
                    }
                }
                // this make tends to fly around than down or up
                // if (velocity.y > 0.) velocity.y *= (1. - 0.2 * delta);
                // Speed Limits
                if ( length( velocity ) > limit ) {
                    velocity = normalize( velocity ) * limit;
                }

                velocity +=v/2;
                velocity /=v;

                return  fixed4( velocity, 1.0 );
            }
            ENDCG
        }
    }
}