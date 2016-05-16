using UnityEngine;
using System;

public class PlayerController : MonoBehaviour
{
	public float MovementSpeed;
	public float MaxSpeed;
	public float JumpHeight;
	public float distToGround;
	public bool ControlLayout;
    public float BrakeForce;
	public int Team;
	public bool DisableMovement;

	public GameObject [] TeleportPoints = new GameObject[10];
	private KeyCode [,] TeleportKeys = new KeyCode[2, 10]
	{
		{
			KeyCode.Alpha0,
			KeyCode.Alpha1,
			KeyCode.Alpha2,
			KeyCode.Alpha3,
			KeyCode.Alpha4,
			KeyCode.Alpha5,
			KeyCode.Alpha6,
			KeyCode.Alpha7,
			KeyCode.Alpha8,
			KeyCode.Alpha9
		},
		{
			KeyCode.Keypad0,
			KeyCode.Keypad1,
			KeyCode.Keypad2,
			KeyCode.Keypad3,
			KeyCode.Keypad4,
			KeyCode.Keypad5,
			KeyCode.Keypad6,
			KeyCode.Keypad7,
			KeyCode.Keypad8,
			KeyCode.Keypad9
		}
	};

	private bool CanJump;
	private Rigidbody2D PhysicBody;

	private void Start()
    {
		PhysicBody = GetComponent<Rigidbody2D>();
	}

	// Update is for cheat purpose only
	private void Update()
	{
		int LayoutIndex = (ControlLayout) ? 1 : 0;
		for (int i = 0; i < 10; i++)
		{
			if (Input.GetKeyDown(TeleportKeys[LayoutIndex, i]))
			{
				TeleportToObject(TeleportPoints[i]);
			}
		}	
	}

    private void FixedUpdate()
    {
		float MovementX = 0.0f, MovementY = 0.0f;

		if (!DisableMovement)
		{
			if (ControlLayout == false)
			{
				MovementX = Input.GetAxisRaw("Horizontal");
				MovementY = Input.GetAxisRaw("Vertical");
			}
			else
			{
				MovementX = Input.GetAxisRaw("Horizontal 2nd");
				MovementY = Input.GetAxisRaw("Vertical 2nd");
			}
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

	public void TeleportToPoint(Vector3 Point)
	{
		transform.position = Point;
	}

	public void TeleportToObject(GameObject Object)
	{
		if (Object != null)
		{
			transform.position = Object.transform.position;
		}
	}
}
