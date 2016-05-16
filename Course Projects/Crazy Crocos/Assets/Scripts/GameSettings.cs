using System;
using System.IO;
using UnityEngine;

public class GameSettings
{
	public static GameSettings ActiveSettings;

	public bool FullScreen;
	public bool EnableSound;
	public float SoundVolume;

	public GameSettings(bool EnableSound, float SoundVolume, bool FullScreen)
	{
		this.EnableSound = EnableSound;
		this.SoundVolume = SoundVolume;
		this.FullScreen = FullScreen;
	}

	public GameSettings(GameSettings Copy)
	{
		FullScreen = Copy.FullScreen;
		EnableSound = Copy.EnableSound;
		SoundVolume = Copy.SoundVolume;
	}

	public static void Load(bool EnableSound, float Volume, bool FullScreen)
	{
		ActiveSettings = new GameSettings(EnableSound, Volume, FullScreen);
	}

	public static GameSettings GetDefaults()
	{
		return new GameSettings(true, 0.75f, false);
	}

	public override string ToString()
	{
		return string.Format("{0}\n{1}\n{2}\n{3}",
			PlayerManager.Instance.ActivePlayer.Name,
			EnableSound ? "1" : "0", SoundVolume, FullScreen ? "1" : "0");
	}

	public static void Update()
	{
		try
		{
			File.WriteAllText(PlayerManager.SettingsPath, ActiveSettings.ToString());
		}
		catch (Exception)
		{
			Debug.LogError("Failed to save game settings!");
		}
	}
}
