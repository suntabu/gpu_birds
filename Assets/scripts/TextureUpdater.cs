using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TextureUpdater : MonoBehaviour
{
    public int width;
    public Material usedMat;

    public Action<Texture2D> OnPostRenderFinished;

    private RenderTexture buffer;
    private RenderTexture texture;


    private Texture2D initialTex;

    public RenderTexture Init()
    {
        initialTex = new Texture2D(width, width, TextureFormat.RGBA32, false);

        texture = new RenderTexture(width, width, 24, RenderTextureFormat.RGB565, RenderTextureReadWrite.Default);
        texture.Create();
        GenerateTexture();

        Graphics.Blit(initialTex, texture);
        buffer = new RenderTexture(texture.width, texture.height, texture.depth, texture.format);
        buffer.Create();
        StartCoroutine(UpdateTexture());

        return texture;
    }



   


    IEnumerator UpdateTexture()
    {
        while(true){
            Graphics.Blit(texture, buffer, usedMat);
            Graphics.Blit(buffer, texture);

            RenderTexture.active = texture;// The RenderTexture.


            var rtData = new Texture2D(texture.width, texture.height);
            rtData.ReadPixels(new Rect(0, 0, texture.width, texture.height), 0, 0);
            rtData.Apply();


            if (OnPostRenderFinished != null)
            {
                OnPostRenderFinished(rtData);
            }

            yield return new WaitForSeconds(.1f);
        }

        yield return null;
    }

    private void GenerateTexture(){
        for (var i = 0; i < initialTex.width; i++)
        {
            for (var j = 0; j < initialTex.height; j++)
            {
                var x = UnityEngine.Random.Range(0, 255) / 255f;
                var y = UnityEngine.Random.Range(0, 255) / 255f;
                var z = UnityEngine.Random.Range(0, 255) / 255f;

                initialTex.SetPixel(i, j, new Color(x, y, z, 1));
            }
        }

        initialTex.Apply();
    }
}
