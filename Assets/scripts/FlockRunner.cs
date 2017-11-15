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

	public GameObject prefab;

	GameObject[] goes;

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

		goes = new GameObject[width];
		for (int i = 0; i < width; i++) {
			goes [i] = Instantiate (prefab);
		}



	}

	void Update ()
	{
		RenderTexture.active = positionRT;// The RenderTexture.
		Texture2D positionData = new Texture2D (positionRT.width, positionRT.height);
		positionData.ReadPixels (new Rect (0, 0, width, width), 0, 0);

		for (int i = 0; i < width; i++) {
			var go = goes [i];
			var rgb = positionData.GetPixel (i, 0);
			go.transform.position = new Vector3 (rgb.r, rgb.g, rgb.b) * 100;
		}

	}
}
