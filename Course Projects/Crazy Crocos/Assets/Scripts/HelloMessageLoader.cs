using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class HelloMessageLoader : MonoBehaviour
{
	void Start ()
	{
		LevelManager.CreateInstance();
		PlayerManager.CreateInstance();

		if (PlayerManager.Instance.ActivePlayer != null)
		{
			SetText(PlayerManager.Instance.ActivePlayer.Name);
		}
		else
		{
			SetText("...");
		}
	}

	void SetText(string Name)
	{
		gameObject.GetComponent<Text>().text = string.Format("Hello, {0}!", Name);
	}
}
