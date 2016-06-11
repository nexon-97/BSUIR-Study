using UnityEngine;
using UnityEngine.SceneManagement;

public class Transition : MonoBehaviour
{
	public static string NextLevelName;
	public static int CurrentLevelId;

	public static string PendingLevelName;
	public static Transition Instance;

	void Start()
	{
		CurrentLevelId = GetCurrentLevelId();
		if (CurrentLevelId != -1 && LevelManager.Instance.LevelsCount > CurrentLevelId + 1)
		{
			NextLevelName = LevelManager.Instance.LevelNames[CurrentLevelId + 1];
		}
		else
		{
			NextLevelName = "-1";
		}

		Instance = this;
	}

	public int GetCurrentLevelId()
	{
		LevelManager.CreateInstance();
		LevelManager manager = LevelManager.Instance;
		for (int i = 0; i < manager.LevelsCount; i++)
		{
			if (manager.LevelNames[i].Equals(SceneManager.GetActiveScene().name))
			{
				return i;
			}
		}

		return -1;
	}

	public void LoadNextLevel()
	{
		if (!NextLevelName.Equals("-1"))
		{
			SceneManager.LoadScene(NextLevelName);
		}
	}

	public void SwitchToLevelSelectionScene()
	{
		GoToLevel("LevelSelectionScene");
	}

	public void SwitchToMainMenu()
	{
		GoToLevel("MainMenuScene");
	}

	public void QuitGame()
	{
		Application.Quit();
	}

	public void GoToLevel(string LevelName)
	{
		PendingLevelName = LevelName;
	}

	private void Update()
	{
		if (PendingLevelName != null)
		{
			SceneManager.LoadScene(PendingLevelName);
			PendingLevelName = null;
		}
	}
}