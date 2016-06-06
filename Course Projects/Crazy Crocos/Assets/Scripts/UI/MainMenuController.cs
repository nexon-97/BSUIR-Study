using UnityEngine;
using UnityEngine.UI;

public class MainMenuController : MonoBehaviour
{
	public GameObject MainLayout;
	public GameObject RegisterWindow;
	public GameObject SettingsPanel;
	public GameObject LogInWindow;
	public GameObject MessageBox;

	public Text SelectedSettingsPlayerText;
	public Text HelloMessageText;
	public Text OfflineHint;
	public Text MessageBoxText;

	public Slider VolumeSlider;
	public Toggle SoundToggle;
	public Button StartGameButton;

	public GameSettings TempSettings;
	public AudioSource MenuAudioSource;

	private GameObject[] ScreenStack;
	private GameObject ActiveScreen;
	public GameObject LogInPanel;

	public static MainMenuController Instance;

	private void Start()
	{
		InitScreenStack();
		SetActiveScreen(MainLayout);

		Instance = this;
	}

	private void InitScreenStack()
	{
		ScreenStack = new GameObject[]
		{
			MainLayout,
			RegisterWindow,
			SettingsPanel,
			LogInWindow,
			MessageBox
		};

		foreach (var Screen in ScreenStack)
		{
			Screen.SetActive(false);
		}
	}

	public void SetActiveScreen(GameObject NewScreen)
	{
		if (ActiveScreen != null)
		{
			ActiveScreen.SetActive(false);
		}
		
		ActiveScreen = NewScreen;
		ActiveScreen.SetActive(true);

		UpdateNetworkInfo();
	}

	public void OpenRegisterWindow()
	{
		SetActiveScreen(RegisterWindow);
	}

	public void OpenLogInWindow()
	{
		SetActiveScreen(LogInWindow);
	}

	public void OpenSettingsPanel()
	{
		if (PlayerManager.Instance.ActivePlayer != null)
		{
			SetActiveScreen(SettingsPanel);

			PlayerInfo CurrentInfo = PlayerManager.Instance.ActivePlayer;
			SelectedSettingsPlayerText.text = string.Format("Selected Player: {0}", CurrentInfo.Name);

			// Create temporary settings
			TempSettings = new GameSettings(GameSettings.ActiveSettings);
			UpdatePlayerSettingsVisual();
		}
	}

	public void OpenMainLayout()
	{
		SetActiveScreen(MainLayout);
	}

	public void ShowMessageBox(string Text)
	{
		MessageBoxText.text = Text;
		SetActiveScreen(MessageBox);
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

	public void UpdateNetworkInfo()
	{
		bool PlayerAuthorized = NetworkController.Instance.ActivePlayer.Authorized;

		UpdateHelloMessageText();

		LogInPanel.SetActive(!PlayerAuthorized);
		OfflineHint.gameObject.SetActive(!PlayerAuthorized);
		StartGameButton.interactable = PlayerAuthorized;
	}

	public void UpdateHelloMessageText()
	{
		NetworkPlayer ActivePlayer = NetworkController.Instance.ActivePlayer;
		if (ActivePlayer != null && ActivePlayer.Authorized)
		{
			HelloMessageText.text = string.Format("Hello, {0}!", ActivePlayer.Nickname);
			HelloMessageText.gameObject.SetActive(true);
		}
		else
		{
			HelloMessageText.gameObject.SetActive(false);
			HelloMessageText.text = string.Empty;
		}
	}
}
