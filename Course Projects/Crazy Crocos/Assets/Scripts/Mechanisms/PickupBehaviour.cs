using UnityEngine;

public class PickupBehaviour : MonoBehaviour
{
	public int Team;
	
	void OnTriggerEnter2D(Collider2D collided)
	{
		if (collided.gameObject.tag.Equals("Player"))
		{
			PlayerController controller = collided.gameObject.GetComponent<PlayerController>() as PlayerController;

			if (controller != null)
			{
				LevelController.GetInstance().AddGem(Team);
				Destroy(gameObject);
			}
		}
	}
}
