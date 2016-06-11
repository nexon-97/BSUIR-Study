using UnityEngine;
using System;
using Nexon;

public class PlayerController : ReplicatedObject
{
	public float MovementSpeed;
	public float MaxSpeed;
	public float JumpHeight;
	public float distToGround;
    public float BrakeForce;
	public int Team;
	public bool DisableMovement;

	private bool CanJump;
	private Rigidbody2D PhysicBody;
	private float GlobalTime;

	private Vector3 NetworkPosition;
	private Vector2 NetworkVelocity;
	private bool PendingNetworkUpdate;

	public NetworkPlayer Owner;

	private void Start()
    {
		PhysicBody = GetComponent<Rigidbody2D>();
	}

    private void FixedUpdate()
    {
		float MovementX = 0.0f, MovementY = 0.0f;

		if (!DisableMovement)
		{
			MovementX = Input.GetAxisRaw("Horizontal");
			MovementY = Input.GetAxisRaw("Vertical");
		}

		float VelocitySign = (MovementX >= 0.0f) ? 1.0f : -1.0f;
		PhysicBody.velocity += new Vector2(MovementX, 0.0f) * MovementSpeed;
		if (Mathf.Abs(PhysicBody.velocity.x) > MaxSpeed)
		{
			PhysicBody.velocity = new Vector2(MaxSpeed * VelocitySign, PhysicBody.velocity.y);
		}

		bool WantsJump = (MovementY == 1.0f);
		if (IsGrounded() && WantsJump)
		{
			PhysicBody.velocity = new Vector2(PhysicBody.velocity.x, JumpHeight);
		}

		Brake();

		GlobalTime += Time.fixedDeltaTime;

		// Send sync data to partner
		if (!DisableMovement && GlobalTime >= 1.0f)
		{
			GlobalTime = 0.0f;

			OnlineGameState GameState = OnlineGameState.Instance;

			// Send player position and velocity
			string UpdatePackage = string.Format(
				"{0}${1}${2}${3}",
				transform.localPosition.x,
				transform.localPosition.y,
				PhysicBody.velocity.x,
				PhysicBody.velocity.y
			);
			TCPMessage Message = new TCPMessage(TCPCommand.PlayerControllerUpdate, UpdatePackage);
			GameState.SendTCPMessageToPartner(Message);
		}
		else if (DisableMovement && PendingNetworkUpdate)
		{
			PhysicBody.isKinematic = true;
			GetComponent<BoxCollider2D>().enabled = false;

			PendingNetworkUpdate = false;
			transform.localPosition = NetworkPosition;
			PhysicBody.velocity = NetworkVelocity;
		}
    }

	private bool IsGrounded()
	{
		RaycastHit2D HitInfo = Physics2D.Raycast(transform.position, -Vector2.up, distToGround + 0.05f, 0x100);
		return (HitInfo.collider != null);
	}

    private void Brake()
    {
        if (IsGrounded())
        {
            // Apply brake force if grounded
            int Sign = Math.Sign(PhysicBody.velocity.x);
            float Module = Math.Abs(PhysicBody.velocity.x);

            if (Module > 0.0f)
            {
                // Apply brake
                PhysicBody.velocity = new Vector2((Module - BrakeForce) * Sign, PhysicBody.velocity.y);

                // Finally stop player movement, if module has changed
                if (Math.Sign(PhysicBody.velocity.x) != Sign)
                {
                    PhysicBody.velocity = new Vector2(0.0f, PhysicBody.velocity.y);
                }
            }
        }
    }

	public void Kill()
	{
		Destroy(gameObject);
	}

	public void SetNetworkController()
	{
		OnlineGameState.Instance.PartnerController = this;
	}

	public void RegisterNetworkUpdate(Vector3 position, Vector2 velocity)
	{
		NetworkPosition = position;
		NetworkVelocity = velocity;
		PendingNetworkUpdate = true;
	}
}
