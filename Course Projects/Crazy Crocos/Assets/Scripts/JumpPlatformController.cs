using UnityEngine;

public class JumpPlatformController : MonoBehaviour
{
	public float SpringStrength;

	void OnTriggerEnter2D(Collider2D collider)
	{
		Rigidbody2D rigidbody = collider.gameObject.GetComponent<Rigidbody2D>();
		if (rigidbody != null)
		{
			Vector2 velocity = rigidbody.velocity;
			velocity.y = -velocity.y * SpringStrength;
			rigidbody.velocity = velocity;
		}
	}
}
