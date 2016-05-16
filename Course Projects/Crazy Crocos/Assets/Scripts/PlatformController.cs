using UnityEngine;
using System.Collections.Generic;

public class PlatformController : MonoBehaviour
{
	private Dictionary<GameObject, Vector3> StickedObjects;

	void Start()
	{
		StickedObjects = new Dictionary<GameObject, Vector3>();
	}

	// Update is called once per frame
	void FixedUpdate()
	{
		foreach (var item in StickedObjects)
		{
			Vector3 position = item.Key.transform.position;
			position.y = gameObject.transform.position.y + item.Value.y;

			item.Key.transform.position = position;
		}
	}

	void OnCollisionEnter2D(Collision2D collision)
	{
		GameObject obj = collision.gameObject;
		if (!StickedObjects.ContainsKey(obj))
		{
			StickedObjects.Add(obj, obj.transform.position - gameObject.transform.position);
		}
		
		Debug.Log("OnCollisionEnter2D");
	}

	void OnCollisionExit2D(Collision2D collision)
	{
		GameObject obj = collision.gameObject;
		if (StickedObjects.ContainsKey(obj))
		{
			StickedObjects.Remove(obj);
		}
	}
}
