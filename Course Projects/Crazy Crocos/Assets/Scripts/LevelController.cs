﻿using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class LevelController : MonoBehaviour
{
	#region Singleton
	private static LevelController controllerSample;

	public static LevelController GetInstance()
	{
		return controllerSample;
	}
	#endregion

	enum LevelState
	{
		InProgress,
		Paused,
		Failed,
		Completed
	}

	public GameObject gameFailedPanel;
	public GameObject gameCompletedPanel;
	public int[] LevelGemsToGather;
	public GameObject FinalCloud;
	public Text TimeText;
	public AudioSource LevelThemeSound;
	public AudioSource FailSound;
	public int [] LevelStarsMapping;
	public GameObject FinalStarsImage;
	public GameObject [] TeamSpawnPoints;
	public GameObject[] TeamGemsSpawnPoints;
	public int[] TeamGemsOwner;

	private LevelState levelState;
	public static PlayerController[] PlayerControllers = new PlayerController [2];
	private int [] LevelGems;
	private float LevelTime;

	private void Start()
	{
		// Create player and level managers
		LevelManager.CreateInstance();
		PlayerManager.CreateInstance();

		controllerSample = this;

		levelState = LevelState.InProgress;
		gameFailedPanel.SetActive(false);
		gameCompletedPanel.SetActive(false);
		LevelGems = new int [2];

		SpawnPlayers();
		SpawnGems();
	}

	private void SpawnPlayers()
	{
		int [] PlayerPrefabsId = new int[2];
		PlayerPrefabsId[0] = PlayerManager.Instance.ActivePlayer.LeftTeam;
		PlayerPrefabsId[1] = PlayerManager.Instance.ActivePlayer.RightTeam;

		for (int i = 0; i < 2; i++)
		{
			GameObject PlayerObject = Instantiate(PlayerVisualInfoStorage.GetPlayerPrefab(PlayerPrefabsId[i]));
			PlayerObject.transform.position = TeamSpawnPoints[i].transform.position;

			PlayerController controller = PlayerObject.GetComponent<MonoBehaviour>() as PlayerController;
			controller.Team = PlayerPrefabsId[i];
			controller.ControlLayout = (i > 0);
			PlayerControllers[i] = controller;
		}
	}

	private void SpawnGems()
	{
		int[] PlayerGemsId = new int[2];
		PlayerGemsId[0] = PlayerManager.Instance.ActivePlayer.LeftTeam;
		PlayerGemsId[1] = PlayerManager.Instance.ActivePlayer.RightTeam;

		for (int i = 0; i < TeamGemsSpawnPoints.Length; i++)
		{
			int GemTeam = PlayerGemsId[TeamGemsOwner[i]];
			GameObject Gem = Instantiate(PlayerVisualInfoStorage.GetGemPrefab(GemTeam));
			PickupBehaviour gemController = Gem.GetComponent<PickupBehaviour>();
			gemController.Team = GemTeam;
			Gem.transform.position = TeamGemsSpawnPoints[i].transform.position;
		}
	}

	public void RestartLevel()
	{
		SceneManager.LoadScene(SceneManager.GetActiveScene().name);
	}

	public void SetLevelFailed()
	{
		levelState = LevelState.Failed;
		gameFailedPanel.SetActive(true);
		DeactivatePlayerContollers();

		if (GameSettings.ActiveSettings.EnableSound)
		{
			FailSound.volume = GameSettings.ActiveSettings.SoundVolume;
			FailSound.mute = false;
			FailSound.Play();
		}
	}

	public void SetLevelCompleted()
	{
		levelState = LevelState.Completed;
		gameCompletedPanel.SetActive(true);
		DeactivatePlayerContollers();

		int StarsCount = GetStarsCount();
		FinalStarsImage.GetComponent<Image>().sprite = StarImagesStorage.GetStarImage(StarsCount);

		// Update level stats
		LevelStats LevelStats = PlayerManager.Instance.ActivePlayer.LevelsInfo[Transition.CurrentLevelId];
		if (!LevelStats.Passed)
		{
			LevelStats.Minutes = (int)LevelTime / 60;
			LevelStats.Seconds = (int)LevelTime % 60;
			LevelStats.Passed = true;
		}
		else if ((int)LevelTime < LevelStats.Minutes * 60 + LevelStats.Seconds)
		{
			LevelStats.Minutes = (int)LevelTime / 60;
			LevelStats.Seconds = (int)LevelTime % 60;
		}

		LevelStats.Stars = StarsCount;
		PlayerManager.Instance.ActivePlayer.LevelsInfo[Transition.CurrentLevelId] = LevelStats;

		// Unlock next level
		if (LevelManager.Instance.LevelsCount > Transition.CurrentLevelId + 1)
		{
			PlayerManager.Instance.ActivePlayer.LevelsInfo[Transition.CurrentLevelId + 1].Available = true;
		}

		PlayerManager.Instance.ActivePlayer.SaveToFile();
	}
	
	public int GetTeamLocalId(int team)
	{
		return (PlayerManager.Instance.ActivePlayer.LeftTeam == team) ? 0 : 1;
	}

	public void AddGem(int team)
	{
		int TeamId = GetTeamLocalId(team);
		LevelGems[TeamId]++;

		int GemsFoundFactor = 0;
		const int TeamsCount = 2;
		for (int i = 0; i < TeamsCount; i++)
		{
			if (LevelGems[i] >= LevelGemsToGather[i])
			{
				GemsFoundFactor++;
			}
		}

		// If all teams gathered their gems - remove cloud from exit door
		if (GemsFoundFactor == TeamsCount)
		{
			DestroyFinalCloud();
		}
	}

	public PlayerController GetPlayerController(int team)
	{
		return PlayerControllers[team];
	}

	public void DestroyFinalCloud()
	{
		if (FinalCloud != null)
		{
			CloudController controller = FinalCloud.GetComponent<CloudController>();
			if (controller != null)
			{
				controller.FadeOut();
			}
			else
			{
				Destroy(FinalCloud);
			}
		}
	}

	public void DeactivatePlayerContollers()
	{
		foreach (var controller in PlayerControllers)
		{
			controller.DisableMovement = true;
		}
	}

	public int GetStarsCount()
	{
		if (levelState == LevelState.Completed)
		{
			int FinalTime = (int)LevelTime;

			if (FinalTime <= LevelStarsMapping[0])
			{
				return 3;
			}
			else if (FinalTime <= LevelStarsMapping[1])
			{
				return 2;
			}

			return 1;
		}

		return 0;
	}


	private void Update()
	{
		if (Input.GetKeyDown(KeyCode.E))
		{
			for (int i = 0; i < 10; i++)
			{
				AddGem(0);
				AddGem(1);
			}
		}
		if (Input.GetKeyDown(KeyCode.R))
		{
			LevelTime += 10.0f;
		}
		if (Input.GetKeyDown(KeyCode.T))
		{
			SetLevelCompleted();
		}

		if (levelState == LevelState.InProgress)
		{
			LevelTime += Time.deltaTime;
			if (TimeText != null)
			{
				int seconds = (int) (LevelTime);
				TimeText.text = string.Format("{0}:{1:00}", seconds / 60, seconds % 60);
			}
		}
	}
}