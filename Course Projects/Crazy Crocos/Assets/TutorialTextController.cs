using UnityEngine;
using UnityEngine.UI;

public class TutorialTextController : MonoBehaviour
{
	public float FadeOutDuration;

	private bool IsFading;
	private float FadeProgress;

	// Use this for initialization
	void OnTriggerEnter2D(Collider2D collider)
	{
		FadeOut();
	}

	// Update is for cheat purpose only
	private void Update()
	{
		if (IsFading)
		{
			FadeProgress += Time.deltaTime * FadeOutDuration;
			Color SourceColor = GetComponent<Text>().color;
			GetComponent<Text>().color = new Color(SourceColor.r, SourceColor.g, SourceColor.b, 1.0f - FadeProgress);

			if (FadeProgress >= 1.0f)
			{
				Destroy(gameObject);
			}
		}
	}

	public void FadeOut()
	{
		FadeProgress = 0.0f;
		IsFading = true;
	}
}
