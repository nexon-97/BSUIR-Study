using UnityEngine;
using System.Collections;

public class ButtonController : MonoBehaviour
{
	const int PlayerLayer = 9;

	public bool ButtonState;
	public GameObject ConnectedObject;
	public int OverlappedObjectsCount;

	public float PushedOffset;
	public float PushSpeed;
	public GameObject Indicator;
	private float OriginalY;


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
		}
	}

	void OnTriggerExit2D(Collider2D collider)
	{
		if (collider.gameObject.layer == PlayerLayer)
		{
			OverlappedObjectsCount--;
			UpdateState(false);		
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
}
