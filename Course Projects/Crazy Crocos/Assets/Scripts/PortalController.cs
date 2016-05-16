using UnityEngine;
using System.Collections;

public class PortalController : MonoBehaviour
{
	public GameObject Destination;
	public Vector2 OutVelocity;

	void OnTriggerEnter2D(Collider2D collided)
	{
		GameObject obj = collided.gameObject;
		Rigidbody2D rigidBody = obj.GetComponent<Rigidbody2D>();
		float speed = rigidBody.velocity.magnitude;

		obj.transform.position = Destination.transform.position;
		rigidBody.velocity = OutVelocity * speed;
	}
}
