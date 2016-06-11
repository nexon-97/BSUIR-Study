using UnityEngine;

public class PoisonAnimationController : MonoBehaviour
{
	public float animSpeed;
	private Animator animator;
	private SpriteRenderer srenderer;

	public bool [] KillPlayer = new bool [2];

	void Start()
	{
		animator = GetComponent<Animator>();
		srenderer = GetComponent<SpriteRenderer>();
		animator.speed = animSpeed;

		if (KillPlayer[0] && KillPlayer[1])
		{
			srenderer.color = new Color(72.0f / 256.0f, 0.0f, 1.0f);
		}
		else
		{
			int TeamId = (KillPlayer[0]) ? 1 : 0;
			int Team = LevelController.PlayerControllers[TeamId].Team;
		}
	}

	void OnTriggerEnter2D(Collider2D collided)
	{
		if (collided.gameObject.tag.Equals("Player"))
		{
			PlayerController controller = collided.gameObject.GetComponent<PlayerController>();
			// React only to players, controlled by a real player
			if (controller != null && !controller.DisableMovement)
			{
				/*if (KillPlayer[controller.Owner.OrderInTeam])
				{
					controller.Kill();
					LevelController.GetInstance().SetLevelFailed();
				}*/
			}	
		}
	}
}
