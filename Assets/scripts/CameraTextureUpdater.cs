#define unsafe
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.IO;
using System;
using System.Runtime.InteropServices;

public class CameraTextureUpdater : MonoBehaviour
{
	public RenderTexture rt;
	public Texture2D rtData;

	public Action<Texture2D> OnPostRenderFinished;

	void Start ()
	{
		
	}

	public void OnPostRender ()
	{
		RenderTexture.active = rt;// The RenderTexture.
 

		rtData = new Texture2D (rt.width, rt.height);
		rtData.ReadPixels (new Rect (0, 0, rt.width, rt.width), 0, 0);
		rtData.Apply ();
		 
 
		if (OnPostRenderFinished != null) {
			OnPostRenderFinished (rtData);
		}

//
//		File.WriteAllBytes ("s_" + Time.realtimeSinceStartup + ".jpg", rtData.EncodeToJPG ());
	}
}
