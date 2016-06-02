using UnityEngine;

public class StarImagesStorage : MonoBehaviour
{
	public static StarImagesStorage Storage;

	public Sprite[] StarImages;

	void Start ()
	{
		Storage = this;
	}
	
	public static Sprite GetStarImage(int count)
	{
		return Storage.StarImages[count];
	}
}
