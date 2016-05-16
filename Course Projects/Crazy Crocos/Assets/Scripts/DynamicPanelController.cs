using System;
using UnityEngine;

public class DynamicPanelController : MonoBehaviour, ISwitchable
{
	public Vector3 EnabledPosition;
	public Vector3 DisabledPosition;
	public float MovementSpeed;
	public bool ShouldMoveBack;

	private Vector3 DesiredPosition;


	private void Start()
	{
		DesiredPosition = DisabledPosition;
	}

	private void FixedUpdate()
	{
		Vector3 CurrentPosition = transform.localPosition;
		Vector3 DeltaPosition = DesiredPosition - CurrentPosition;
		float DistanceToDisredPos = DeltaPosition.magnitude;
		float Multiplier = (DistanceToDisredPos < MovementSpeed) ? DistanceToDisredPos : MovementSpeed;
		Vector3 MovementDirection = DeltaPosition.normalized * Multiplier;
		
		transform.localPosition += MovementDirection;

		if (ShouldMoveBack && IsInExtremePosition())
		{
			SwapDesiredPosition();
		}
	}

	public bool IsInExtremePosition()
	{
		return (transform.localPosition == DesiredPosition);
	}

	public void SwapDesiredPosition()
	{
		DesiredPosition = (DesiredPosition == EnabledPosition) ? DisabledPosition : EnabledPosition;
	}

	#region ISwitchable implementation
	public void Disable()
	{
		DesiredPosition = DisabledPosition;
	}

	public void Enable()
	{
		DesiredPosition = EnabledPosition;
	}
	#endregion
}
