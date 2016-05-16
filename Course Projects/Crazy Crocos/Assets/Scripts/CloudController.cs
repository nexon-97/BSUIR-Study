using UnityEngine;
using System.Collections;

public class CloudController : MonoBehaviour
{
	public float FadeDuration;

	private bool IsFading;
	private float FadeProgress;
	private SpriteRenderer sriteRenderer;

	// Use this for initialization
	void Start ()
	{
		sriteRenderer = GetComponent<SpriteRenderer>();
	}

	// Update is for cheat purpose only
	private void Update()
	{
		if (IsFading)
		{
			FadeProgress += Time.deltaTime * FadeDuration;
			sriteRenderer.color = new Color(1.0f, 1.0f, 1.0f, 1.0f - FadeProgress);

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
