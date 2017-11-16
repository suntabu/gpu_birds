using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlockRunner : MonoBehaviour
{
	public int width = 8;

	public Camera camera, camera1;

	static string positionTexKey = "_PositionTex";
	static string velocityTexKey = "_VelocityTex";

	RenderTexture positionRT, velocityRT;

	public MeshRenderer positionQuad, velocityQuad;

	public GameObject prefab;

	GameObject[] goes;

	private int count;

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

		count = width * width;
		goes = new GameObject[count];
		for (int i = 0; i < count; i++) {
			goes [i] = Instantiate (prefab);
		}



	}

	void Update ()
	{
		RenderTexture.active = positionRT;// The RenderTexture.
		Texture2D positionData = new Texture2D (positionRT.width, positionRT.height);
		positionData.ReadPixels (new Rect (0, 0, width, width), 0, 0);

		for (int i = 0; i < count; i++) {
			var go = goes [i];
			var x = i / width;
			var y = i % width;
			var rgb = positionData.GetPixel (x, y);
			go.transform.position = new Vector3 (rgb.r, rgb.g, rgb.b) * 100;
		}

	}
}
