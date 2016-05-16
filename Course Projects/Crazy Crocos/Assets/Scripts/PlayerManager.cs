using UnityEngine;
using System.IO;
using System;

public class PlayerManager
{
	#region Fields
	private static PlayerManager _Instance;

	private PlayerInfo [] _Players;
	private PlayerInfo _CurrentPlayer;
	#endregion

	#region Properties
	public static PlayerManager Instance
	{
		get
		{
			return _Instance;
		}
	}

	public const string SettingsPath = @"Data\settings.dat";
	public const string PlayersDirectoryPath = @"Data\players";

	public PlayerInfo [] Players
	{
		get
		{
			return _Players;
		}
		set
		{
			_Players = value;
		}
	}

	public PlayerInfo ActivePlayer
	{
		get
		{
			return _CurrentPlayer;
		}
		set
		{
			_CurrentPlayer = value;
		}
	}
	#endregion

	#region Constructor
	private PlayerManager()
	{
		LoadPlayers();

		if (File.Exists(SettingsPath))
		{
			string [] Lines = File.ReadAllLines(SettingsPath);
			string name = Lines[0];

			try
			{
				GameSettings.Load(Lines[1].Equals("1"), float.Parse(Lines[2]), Lines[3].Equals("1"));
			}
			catch (Exception)
			{
				GameSettings.ActiveSettings = GameSettings.GetDefaults();
			}

			// Pick active player
			foreach (var item in _Players)
			{
				if (item.Name.Equals(name))
				{
					_CurrentPlayer = item;
					break;
				}
			}
		}
	}
	#endregion

	#region Singleton method
	public static void CreateInstance()
	{
		if (_Instance == null)
		{
			_Instance = new PlayerManager();
		}
	}
	#endregion

	public void LoadPlayers()
	{
		if (Directory.Exists(PlayersDirectoryPath))
		{
			string[] dirFiles = Directory.GetFiles(PlayersDirectoryPath);
			_Players = new PlayerInfo[dirFiles.Length];

			int index = 0;
			foreach (var file in dirFiles)
			{
				PlayerInfo Stats = new PlayerInfo();

				string[] FileContent = File.ReadAllLines(file);

				Stats.Name = FileContent[0];
				Stats.LeftTeam = int.Parse(FileContent[1]);
				Stats.RightTeam = int.Parse(FileContent[2]);

				int LevelsCount = LevelManager.Instance.LevelsCount;
				Stats.LevelsInfo = new LevelStats[LevelsCount];
				for (int i = 0; i < LevelsCount; i++)
				{
					string[] Parts = FileContent[3 + i].Split('|');

					Stats.LevelsInfo[i].Available = Parts[0].Equals("+");
					Stats.LevelsInfo[i].Passed = Parts[1].Equals("+");
					Stats.LevelsInfo[i].Stars = int.Parse(Parts[2]);
					Stats.LevelsInfo[i].Minutes = int.Parse(Parts[3]);
					Stats.LevelsInfo[i].Seconds = int.Parse(Parts[4]);
				}

				_Players[index] = Stats;
				index++;
			}
		}
		else
		{
			Directory.CreateDirectory(PlayersDirectoryPath);
		}
	}

	public void DeletePlayerFile(string PlayerName)
	{
		string FullPath = string.Format(@"{0}\{1}.dat", PlayersDirectoryPath, PlayerName);
		if (File.Exists(FullPath))
		{
			try
			{
				File.Delete(FullPath);
			}
			catch (Exception)
			{
				Debug.LogError("Failed to remove player file!");
			}
		}
	}
}
