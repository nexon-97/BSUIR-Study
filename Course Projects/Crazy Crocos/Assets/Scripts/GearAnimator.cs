using UnityEngine;
using System.Collections;

public class GearAnimator : MonoBehaviour
{
	public GameObject connectedObject;
	public Vector3 enabledPosition;
	public Vector3 disabledPosition;
	public float rotationSpeed;
	
	void Update ()
	{
		if (connectedObject != null)
		{
			Vector3 currentPosition = connectedObject.transform.localPosition;
			float fullDistance = (enabledPosition - disabledPosition).magnitude;
			float deltaDistance = (enabledPosition - currentPosition).magnitude;

			float progress = deltaDistance / fullDistance;

			transform.localRotation = Quaternion.Euler(0.0f, 0.0f, progress * rotationSpeed);
		}
	}
}
