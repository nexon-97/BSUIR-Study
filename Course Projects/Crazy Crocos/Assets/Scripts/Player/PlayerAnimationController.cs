using UnityEngine;

public class PlayerAnimationController : MonoBehaviour
{
	public Sprite [] AnimationSprites;
	public float Speed;

	private float DeltaTimeGlobal;
	private SpriteRenderer SpriteRender;
	private int CurrentSprite;
	private int DestSprite;

	void Start()
	{
		SpriteRender = GetComponent<SpriteRenderer>();
		Speed = 1.0f / Speed;
	}
	
	void Update()
	{
		DeltaTimeGlobal += Time.deltaTime;
		if (DeltaTimeGlobal >= Speed)
		{
			DeltaTimeGlobal -= Speed;

			int DeltaIndex = DestSprite - CurrentSprite;
			if (DeltaIndex != 0)
			{
				CurrentSprite += (DeltaIndex) / Mathf.Abs(DeltaIndex);
			}
			else
			{
				DestSprite = (CurrentSprite == 0) ? AnimationSprites.Length - 1 : 0;
			}
		}
		
		SpriteRender.sprite = AnimationSprites[CurrentSprite];
	}
}
