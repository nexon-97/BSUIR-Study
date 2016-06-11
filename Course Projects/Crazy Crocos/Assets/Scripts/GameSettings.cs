using System;
using System.IO;
using UnityEngine;

public class GameSettings
{
	public const string SettingsPath = @"Data\settings.dat";

	private static GameSettings _ActiveSettings;

	public static GameSettings ActiveSettings
	{
		get
		{
			if (_ActiveSettings == null)
			{
				Load();
			}

			return _ActiveSettings;
		}
		set
		{
			_ActiveSettings = value;
		}
	}

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

	public static void Load()
	{
		if (File.Exists(SettingsPath))
		{
			try
			{
				string[] Lines = File.ReadAllLines(SettingsPath);

				_ActiveSettings = new GameSettings(Lines[0].Equals("1"), float.Parse(Lines[1]), Lines[2].Equals("1"));
			}
			catch (Exception)
			{
				_ActiveSettings = GetDefaults();
				Update();
			}
		}
		else
		{
			_ActiveSettings = GetDefaults();
			Update();
		}
	}

	public override string ToString()
	{
		return string.Format("{0}\n{1}\n{2}", EnableSound ? "1" : "0", SoundVolume, FullScreen ? "1" : "0");
	}

	public static GameSettings GetDefaults()
	{
		return new GameSettings(true, 0.75f, false);
	}

	public static void Update()
	{
		if (_ActiveSettings != null)
		{
			try
			{
				File.WriteAllText(SettingsPath, _ActiveSettings.ToString());
			}
			catch (Exception)
			{
				Debug.LogError("Failed to save game settings!");
			}
		}
	}
}
