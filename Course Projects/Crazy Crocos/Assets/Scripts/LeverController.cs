using UnityEngine;

public class LeverController : MonoBehaviour
{
	public bool State;
	public float Angle;
	public bool StartState;
	public Color ActiveColor;
	public GameObject ConnectedItem;

	private HingeJoint2D joint;
	private SpriteRenderer sprite;
	private Color originalColor;

	void Start ()
	{
		joint = GetComponent<HingeJoint2D>();
		sprite = GetComponent<SpriteRenderer>();
		originalColor = sprite.color;

		if (!StartState)
		{
			GetComponent<Rigidbody2D>().AddForce(new Vector2(-1000.0f, 0.0f));
		}
		else
		{
			GetComponent<Rigidbody2D>().AddForce(new Vector2(1000.0f, 0.0f));
		}
	}
	
	void FixedUpdate ()
	{
		State = joint.jointAngle > 0.0f;
		sprite.color = (State) ? ActiveColor : originalColor;

		if (ConnectedItem != null)
		{
			ISwitchable Switchable = ConnectedItem.GetComponent<MonoBehaviour>() as ISwitchable;
			if (Switchable != null)
			{
				if (State)
				{
					Switchable.Enable();
				}
				else
				{
					Switchable.Disable();
				}
			}
		}
	}
}
