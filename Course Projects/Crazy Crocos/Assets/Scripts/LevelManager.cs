using System.IO;
using UnityEngine;

public class LevelManager
{
	#region Fields
	private static LevelManager _Instance;

	private string [] _LevelNames;
	#endregion

	#region Properties
	public static LevelManager Instance
	{
		get
		{
			return _Instance;
		}
	}

	public string [] LevelNames
	{
		get
		{
			return _LevelNames;
		}
	}

	public int LevelsCount
	{
		get
		{
			return _LevelNames.Length;
		}
	}
	#endregion

	private LevelManager()
	{
		const string ScenesPath = @"Data\scenes.dat";

        if (!File.Exists(ScenesPath))
		{
			Debug.LogError("Scenes data not found!");
		}
		else
		{
			_LevelNames = File.ReadAllLines(ScenesPath);
		}
	}

	public static void CreateInstance()
	{
		if (_Instance == null)
		{
			_Instance = new LevelManager();
		}
	}
}
