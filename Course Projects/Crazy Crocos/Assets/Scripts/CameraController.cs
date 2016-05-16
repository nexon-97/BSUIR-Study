using UnityEngine;
using System.Collections;

public class CameraController : MonoBehaviour
{

    public int SizeX;
    public int SizeY;

    public GameObject Background;

    // Use this for initialization
    void Start ()
    {
        Camera someCamera = GetComponent<Camera>();
        SizeX = someCamera.pixelWidth;
        SizeY = someCamera.pixelHeight;

        int TextureSizeX = 1024;
        int TextureSizeY = 648;
        float UnitSizeX = (TextureSizeX / 100.0f);
        float UnitSizeY = (TextureSizeY / 100.0f);
        Debug.Log(UnitSizeX);
        Debug.Log(UnitSizeY);

        Vector3 myBound = Background.GetComponent<SpriteRenderer>().bounds.size;
        Debug.Log(myBound);
        /*Debug.Log(someCamera.rect);

        Background.transform.localScale = new Vector3();*/
    }

    void Update()
    {

    }
}
