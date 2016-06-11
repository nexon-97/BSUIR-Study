using UnityEngine;
using System.Collections;

public class ButtonController : ReplicatedObject
{
	const int PlayerLayer = 9;

	public bool ButtonState;
	public GameObject ConnectedObject;
	public int OverlappedObjectsCount;

	public float PushedOffset;
	public float PushSpeed;
	public GameObject Indicator;
	private float OriginalY;

	const string ButtonStateProperty = "Button State";


	private void Start()
	{
		// Enable state replication
		RegisterInNetworkContext();
	}

	void Update()
	{
		if (Indicator != null)
		{
			Vector3 localPosition = Indicator.transform.localPosition;

			if (ButtonState == true && localPosition.y != PushedOffset)
			{
				localPosition.y -= PushSpeed * Time.deltaTime;
			}
			else if (ButtonState == false && localPosition.y != 0.0f)
			{
				localPosition.y += PushSpeed * Time.deltaTime;
			}

			localPosition.y = Mathf.Clamp(localPosition.y, PushedOffset, 0.0f);
			Indicator.transform.localPosition = localPosition;
		}
	}

	void OnTriggerEnter2D(Collider2D collider)
	{
		if (collider.gameObject.layer == PlayerLayer)
		{
			OverlappedObjectsCount++;
			UpdateState(true);

			ReplicateProperty(ButtonStateProperty, "true");
		}
	}

	void OnTriggerExit2D(Collider2D collider)
	{
		if (collider.gameObject.layer == PlayerLayer)
		{
			OverlappedObjectsCount--;
			UpdateState(false);

			ReplicateProperty(ButtonStateProperty, "false");
		}
	}

	void UpdateState(bool newState)
	{
		if (newState == false && OverlappedObjectsCount == 0)
		{
			ButtonState = newState;
			TriggerConnectedObject();
		}
		else if (newState == true && OverlappedObjectsCount == 1)
		{
			ButtonState = newState;
			TriggerConnectedObject();
		}
	}

	void TriggerConnectedObject()
	{
		if (ConnectedObject != null)
		{
			MonoBehaviour ObjectScript = ConnectedObject.GetComponent<MonoBehaviour>();
			ISwitchable Switchable = ObjectScript as ISwitchable;
			if (Switchable != null)
			{
				if (ButtonState)
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

	public override void ReplicationNotify(string Property, string Value)
	{
		if (Property.Equals(ButtonStateProperty))
		{
			Debug.LogError("Button State Replicated");

			bool NewValue = Value.Equals("true");
			ButtonState = NewValue;
		}
	}
}
