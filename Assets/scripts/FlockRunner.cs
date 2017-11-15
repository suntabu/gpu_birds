using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlockRunner : MonoBehaviour
{
	public int width = 64;

	public Camera camera, camera1;

	static string positionTexKey = "_PositionTex";
	static string velocityTexKey = "_VelocityTex";

	RenderTexture positionRT, velocityRT;

	public MeshRenderer positionQuad, velocityQuad;

	void Start ()
	{
		positionRT = new RenderTexture (width, width, 24);
		velocityRT = new RenderTexture (width, width, 24);
		positionRT.Create ();
		velocityRT.Create ();

		camera.targetTexture = positionRT;
		camera1.targetTexture = velocityRT;

		positionQuad.material.SetTexture (positionTexKey, positionRT);
		positionQuad.material.SetTexture (velocityTexKey, velocityRT);

		velocityQuad.material.SetTexture (positionTexKey, positionRT);
		velocityQuad.material.SetTexture (velocityTexKey, velocityRT);
	}

	void Update ()
	{
		
	}
}
