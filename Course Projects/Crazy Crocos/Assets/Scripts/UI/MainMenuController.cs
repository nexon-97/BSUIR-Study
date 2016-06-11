using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;

public class MainMenuController : MonoBehaviour
{
	public GameObject MainLayout;
	public GameObject RegisterWindow;
	public GameObject SettingsPanel;
	public GameObject LogInWindow;
	public GameObject MessageBox;
	public GameObject PartnerSelectionWindow;

	public GameObject PartnersChooseRectContent;
	public GameObject PartnerButtonPrefab;

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
	private GameObject[] PartnersButtons;

	public static MainMenuController Instance;

	private void Start()
	{
		InitScreenStack();
		SetActiveScreen(MainLayout);

		Instance = this;
		GameSettings.Load();
	}

	private void InitScreenStack()
	{
		ScreenStack = new GameObject[]
		{
			MainLayout,
			RegisterWindow,
			SettingsPanel,
			LogInWindow,
			MessageBox,
			PartnerSelectionWindow
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
		SetActiveScreen(SettingsPanel);

		// Create temporary settings
		TempSettings = new GameSettings(GameSettings.ActiveSettings);
		UpdatePlayerSettingsVisual();
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

	public void OpenPartnerChooseWindow()
	{
		SetActiveScreen(PartnerSelectionWindow);

		// Load players list
		LoadNetworkPlayersList();
	}

	private void ClearNetworkPlayersList()
	{
		if (PartnersButtons != null)
		{
			foreach (var Button in PartnersButtons)
			{
				Button.SetActive(false);
				Destroy(Button);
			}

			PartnersButtons = null;
		}
	}

	public void LoadNetworkPlayersList()
	{
		// Fetch players list
		string[] Partners = NetworkController.Instance.LoadNetworkPartners();

		ClearNetworkPlayersList();
		PartnersButtons = new GameObject[Partners.Length];

		for (int i = 0; i < Partners.Length; i++)
		{
			string[] LineParts = Partners[i].Split('|');

			int Id = int.Parse(LineParts[0]);
			string Login = LineParts[1];
			bool Online = LineParts[2].Equals("1");

			if (!Online)
			{
				Login += " (Offline)";
			}

			GameObject Button = Instantiate(PartnerButtonPrefab);
			Button.transform.SetParent(PartnersChooseRectContent.transform);
			Button.GetComponentInChildren<Text>().text = Login;
			Button.GetComponentInChildren<Button>().interactable = Online;

			Button.GetComponentInChildren<PartnerButtonController>().Id = Id;

			int YCoord = 180 - 50 * i;
			RectTransform Transform = Button.GetComponent<RectTransform>();
			Vector3 WidgetPos = Transform.localPosition;
			WidgetPos.y = YCoord;
			WidgetPos.x = -245;
			Transform.localPosition = WidgetPos;

			Transform.sizeDelta = new Vector2(-35.0f, 45.0f);

			PartnersButtons[i] = Button;
		}
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
		bool PlayerAuthorized = OnlineGameState.Instance.Player.Authorized;

		UpdateHelloMessageText();

		LogInPanel.SetActive(!PlayerAuthorized);
		OfflineHint.gameObject.SetActive(!PlayerAuthorized);
		StartGameButton.interactable = PlayerAuthorized;
	}

	public void UpdateHelloMessageText()
	{
		NetworkPlayer ActivePlayer = OnlineGameState.Instance.Player;
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
