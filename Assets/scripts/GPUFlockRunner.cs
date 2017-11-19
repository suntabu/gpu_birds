using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GPUFlockRunner : MonoBehaviour
{
    public GameObject prefab;
    public TextureUpdater postionUpdater;
    public TextureUpdater velocityUpdater;

    public RawImage posImage, velImage;

    public Material posMat, velMat;
    void Start()
    {
        int count = 8;
        postionUpdater.usedMat = posMat;
        postionUpdater.width = count;

        velocityUpdater.usedMat = velMat;
        velocityUpdater.width = count;

        var posRT = postionUpdater.Init();
        var velRT = velocityUpdater.Init();

        posMat.SetTexture("_VelocityTex", velRT);
        velMat.SetTexture("_PositionTex", posRT);

        posImage.texture = posRT;
        velImage.texture = velRT;

        GameObject[] goes = new GameObject[count * count];
        for (int i = 0; i < count * count; i++)
        {
            goes[i] = Instantiate(prefab);

        }


        postionUpdater.OnPostRenderFinished = (Texture2D t) => {
            for (int i = 0; i < count * count; i++)
            {
                var go = goes[i];
                var x = i / count;
                var y = i % count;
                var rgb = t.GetPixel(x, y);
                go.transform.position = new Vector3(rgb.r, rgb.g, rgb.b) * 800 - Vector3.one * 400;
            }
        };
    }

    void Update()
    {

    }
}
