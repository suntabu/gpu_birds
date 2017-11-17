using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FlockRunner : MonoBehaviour
{
	int width = 8;

	public Camera camera, camera1;

	static string positionTexKey = "_PositionTex";
	static string velocityTexKey = "_VelocityTex";

	RenderTexture positionRT, velocityRT;

	public MeshRenderer positionQuad, velocityQuad;

	public GameObject prefab;

	public RawImage image1;
	public RawImage image2;
	GameObject[] goes;
	static int BOUNDS = 800, BOUNDS_HALF = BOUNDS / 2;
	private int count;

	public Material mat1;
	public Material mat2;

	public CameraTextureUpdater updater1;
	public CameraTextureUpdater updater2;

	void Start ()
	{
		positionRT = new RenderTexture (width, width, 24);
		velocityRT = new RenderTexture (width, width, 24);
		positionRT.Create ();
		velocityRT.Create ();

		camera.targetTexture = positionRT;
		camera1.targetTexture = velocityRT;
 
		count = width * width;
		goes = new GameObject[count];
		for (int i = 0; i < count; i++) {
			goes [i] = Instantiate (prefab);
		}

		updater1.rt = positionRT;
		updater2.rt = velocityRT;
 


//		updater1.OnPostRenderFinished = t => {
//			image1.texture = t;
//			mat1.SetTexture (positionTexKey, t);
//			mat2.SetTexture (positionTexKey, t);
//		};
//
//		updater2.OnPostRenderFinished = t => {
//			image2.texture = t;
//			mat1.SetTexture (velocityTexKey, t);
//			mat2.SetTexture (velocityTexKey, t);
//		};

		Texture2D tex1 = new Texture2D (width, width);
		Texture2D tex2 = new Texture2D (width, width);

		FillPositionTexture (tex1);
		FillVelocityTexture (tex2);

		image1.texture = tex1;
		image2.texture = tex2;
		mat1.SetTexture (positionTexKey, tex1);
		mat1.SetTexture (velocityTexKey, tex2);
		image1.material = mat1;

		mat2.SetTexture (positionTexKey, tex1);
		mat2.SetTexture (velocityTexKey, tex2);
		image2.material = mat1;
	}

	void Update ()
	{
		if (updater1.rtData) {
			for (int i = 0; i < count; i++) {
				var go = goes [i];
				var x = i / width;
				var y = i % width;
				var rgb = updater1.rtData.GetPixel (x, y);
				go.transform.position = new Vector3 (rgb.r, rgb.g, rgb.b) * BOUNDS;
			}
		}
	}

 
	void FillPositionTexture (Texture2D texture)
	{
		var w = 1f / BOUNDS;

		for (var i = 0; i < texture.width; i++) {
			for (var j = 0; j < texture.height; j++) {
				var x = Random.Range (0, 255) / 255f;
				var y = Random.Range (0, 255) / 255f;
				var z = Random.Range (0, 255) / 255f;

				texture.SetPixel (i, j, new Color (x, y, z, 1));
			}
		}

		texture.Apply ();
	}

	void FillVelocityTexture (Texture2D texture)
	{
		var w = 1f / 10;
		for (var i = 0; i < texture.width; i++) {
			for (var j = 0; j < texture.height; j++) {
				var x = UnityEngine.Random.Range (0, 255) / 255f;
				var y = UnityEngine.Random.Range (0, 255) / 255f;
				var z = UnityEngine.Random.Range (0, 255) / 255f;

				texture.SetPixel (i, j, new Color (x, y, z, 1));
			}
		}
		texture.Apply ();
	}
}
