using UnityEngine;
using UnityEngine.SceneManagement;

public class LevelSelectorButton : MonoBehaviour
{
	public string LevelName;
	public GameObject Locker;
	public GameObject BestTimeText;
	public GameObject StarsImage;

	public void LoadLevel()
	{
		SceneManager.LoadScene(LevelName);
	}

	public void Unlock()
	{
		if (Locker != null)
		{
			Locker.SetActive(false);
		}
	}
}
