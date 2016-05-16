using UnityEngine;

public class AnimationController : MonoBehaviour
{
	public float AnimSpeed;
	
	void Start ()
	{
		GetComponent<Animator>().speed = AnimSpeed;
	}
}
