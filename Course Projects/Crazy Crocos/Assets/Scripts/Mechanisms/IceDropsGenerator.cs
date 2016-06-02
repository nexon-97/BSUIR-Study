using UnityEngine;

public class IceDropsGenerator : MonoBehaviour
{
	public float GeneratorFrequency;
	public GameObject Instance;
	public float GenerationXMin, GenerationXMax;
	public float GenerationY;

	private float TimePassed;

	void Update()
	{
		TimePassed += Time.deltaTime;
		if (TimePassed > GeneratorFrequency)
		{
			TimePassed -= GeneratorFrequency;

			// Spawn new drop
			GameObject drop = Instantiate(Instance);
			drop.transform.position = new Vector3(Random.Range(GenerationXMin, GenerationXMax), GenerationY, 0.0f);
		}
	}
}
