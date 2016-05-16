using UnityEngine;
using UnityEngine.UI;
using System;
using System.IO;

public class MainMenuController : MonoBehaviour
{
	public GameObject MainLayout;
	public GameObject PlayersSelectionPanel;
	public GameObject PlayerCreationMenu;
	public GameObject SettingsPanel;
	public GameObject PlayerFrame;
	public GameObject PlayersList;
	public GameObject [] PlayerFrames;
	public Text SelectedPlayerText;
	public Text SelectedSettingsPlayerText;
	public Text HelloMessageText;

	public Slider VolumeSlider;
	public Toggle SoundToggle;

	public GameSettings TempSettings;
	public AudioSource MenuAudioSource;

	private void Start ()
	{
		MainLayout.SetActive(true);
		PlayersSelectionPanel.SetActive(false);
		PlayerCreationMenu.SetActive(false);
		SettingsPanel.SetActive(false);

		UpdateHelloMessageText();
	}

	public void OpenPlayersSelectionPanel()
	{
		MainLayout.SetActive(false);
		PlayersSelectionPanel.SetActive(true);
		PlayerCreationMenu.SetActive(false);
		SettingsPanel.SetActive(false);

		LoadPlayersList();
	}

	public void OpenPlayerCreationMenu()
	{
		MainLayout.SetActive(false);
		PlayersSelectionPanel.SetActive(false);
		PlayerCreationMenu.SetActive(true);
		SettingsPanel.SetActive(false);
	}

	public void OpenSettingsPanel()
	{
		if (PlayerManager.Instance.ActivePlayer != null)
		{
			MainLayout.SetActive(false);
			PlayersSelectionPanel.SetActive(false);
			PlayerCreationMenu.SetActive(false);
			SettingsPanel.SetActive(true);

			PlayerInfo CurrentInfo = PlayerManager.Instance.ActivePlayer;
			SelectedSettingsPlayerText.text = string.Format("Selected Player: {0}", CurrentInfo.Name);

			// Create temporary settings
			TempSettings = new GameSettings(GameSettings.ActiveSettings);
			UpdatePlayerSettingsVisual();
		}
	}

	public void OpenMainLayout()
	{
		MainLayout.SetActive(true);
		PlayersSelectionPanel.SetActive(false);
		PlayerCreationMenu.SetActive(false);
		SettingsPanel.SetActive(false);
	}

	public void OnApplySettings()
	{
		GameSettings.ActiveSettings = new GameSettings(TempSettings);
		GameSettings.Update();
	}

	public void UpdateSoundState()
	{
		TempSettings.EnableSound = SoundToggle.isOn;
		if (MenuAudioSource != null)
		{
			MenuAudioSource.mute = !TempSettings.EnableSound;
		}
	}


	public void UpdateVolumeState()
	{
		TempSettings.SoundVolume = VolumeSlider.value;
		if (MenuAudioSource != null)
		{
			MenuAudioSource.volume = TempSettings.SoundVolume;
		}
	}

	public void OnResetDefaultSettings()
	{
		TempSettings = new GameSettings(GameSettings.GetDefaults());
		UpdatePlayerSettingsVisual();

		UpdateSoundState();
		UpdateVolumeState();
	}

	public void UpdatePlayerSettingsVisual()
	{
		SoundToggle.isOn = TempSettings.EnableSound;
		VolumeSlider.value = TempSettings.SoundVolume;
	}

	public void SettingsCancel()
	{
		TempSettings = new GameSettings(GameSettings.ActiveSettings);

		if (MenuAudioSource != null)
		{
			MenuAudioSource.mute = !TempSettings.EnableSound;
			MenuAudioSource.volume = TempSettings.SoundVolume;
		}

		OpenMainLayout();
	}

	public void LoadPlayersList()
	{
		foreach (var item in PlayerFrames)
		{
			item.SetActive(false);
		}

		PlayerManager.Instance.LoadPlayers();
		int LoadedCount = 0;
		foreach (var player in PlayerManager.Instance.Players)
		{
			Transform ChildTransform = PlayerFrames[LoadedCount].transform.GetChild(0);
			if (ChildTransform != null)
			{
				Text ChildText = ChildTransform.gameObject.GetComponent<Text>();
				if (ChildText != null)
				{
					ChildText.text = player.Name;
				}
			}

			PlayerFrames[LoadedCount].SetActive(true);
			LoadedCount++;
		}

		UpdateSelectedPlayerText();
	}

	public void SetActivePlayer(Text PlayerNameText)
	{
		string PlayerName = PlayerNameText.text;

		foreach (var player in PlayerManager.Instance.Players)
		{
			if (player.Name.Equals(PlayerName))
			{
				PlayerManager.Instance.ActivePlayer = player;
				GameSettings.Update();
				break;
			}
		}

		UpdateSelectedPlayerText();
		UpdateHelloMessageText();
	}

	public void UpdateSelectedPlayerText()
	{
		SelectedPlayerText.text = string.Format("Selected Player: {0}", PlayerManager.Instance.ActivePlayer.Name);
	}

	public void UpdateHelloMessageText()
	{
		string DisplayedName = (PlayerManager.Instance.ActivePlayer != null)	?
								PlayerManager.Instance.ActivePlayer.Name		:
								"...";
		HelloMessageText.text = string.Format("Hello, {0}!", DisplayedName);
	}

	public void CreatePlayer()
	{
		PlayerInfo CreationInfo = PlayerCreationMenuController.Instance.Info;
		CreationInfo.LevelsInfo = new LevelStats[LevelManager.Instance.LevelsCount];
		CreationInfo.LevelsInfo[0].Available = true;

		// Check if such player already exists
		if (CreationInfo.Name.Length > 0)
		{
			foreach (var player in PlayerManager.Instance.Players)
			{
				if (player.Name.Equals(CreationInfo.Name))
				{
					Debug.Log("Such player already registered!");
					return;
				}
			}

			if (CreationInfo.LeftTeam == CreationInfo.RightTeam)
			{
				Debug.Log("Two equal characters picked!");
				return;
			}

			CreationInfo.SaveToFile();
			OpenPlayersSelectionPanel();
		}
		else
		{
			Debug.Log("Empty name!");
		}
	}

	public void DeleteSelectedPlayer()
	{
		PlayerManager manager = PlayerManager.Instance;
		if (manager.ActivePlayer != null)
		{
			for (int i = 0; i < manager.Players.Length; i++)
			{
				if (manager.ActivePlayer.Name.Equals(manager.Players[i].Name))
				{
					int j = 0;
					PlayerInfo RemovedPlayer = manager.Players[i];
					PlayerInfo[] PlayersArray = new PlayerInfo[manager.Players.Length - 1];

					for (int k = 0; k < manager.Players.Length; k++)
					{
						if (manager.Players[k] != RemovedPlayer)
						{
							PlayersArray[j] = manager.Players[k];
							j++;
						}
					}
					
					manager.Players = PlayersArray;
					break;
				}
			}

			manager.DeletePlayerFile(manager.ActivePlayer.Name);

			if (manager.Players.Length > 0)
			{
				manager.ActivePlayer = manager.Players[0];

				LoadPlayersList();
				UpdateHelloMessageText();
				GameSettings.Update();
			}
		}
	}
}
