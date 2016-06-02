using UnityEngine;
using System.Collections;

public class IceDropController : MonoBehaviour
{
	public Sprite[] Sprites;

	void Start()
	{
		System.Random rand = new System.Random();
		GetComponent<SpriteRenderer>().sprite = Sprites[rand.Next(Sprites.Length)];
	}

	void OnTriggerEnter2D(Collider2D collided)
	{
		if (collided.gameObject.tag == "Player")
		{
			PlayerController controller = collided.gameObject.GetComponent<MonoBehaviour>() as PlayerController;
			if (controller != null)
			{
				controller.Kill();

				LevelController.GetInstance().SetLevelFailed();
			}
		}

		Destroy(gameObject);
	}
}
