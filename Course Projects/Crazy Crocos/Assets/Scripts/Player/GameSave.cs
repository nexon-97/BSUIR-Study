using System.Net;
using UnityEngine;

public struct LevelStats
{
	public bool Available;
	public bool Passed;
	public int Minutes;
	public int Seconds;
	public int Stars;
}

public class GameSave
{
	public LevelStats [] LevelsInfo;

	public bool LevelAvailable(int index)
	{
		return LevelsInfo[index].Available;
	}

	public bool LevelPassed(int index)
	{
		return LevelsInfo[index].Passed;
	}

	public void LoadFromServer(int TeamId)
	{
		OnlineGameState GameState = OnlineGameState.Instance;

		if (GameState.Player != null && GameState.Partner != null)
		{
			HttpWebRequest Request = WebServices.GeneratePostRequest(
				"team",
				new System.Collections.Generic.Dictionary<string, string>()
				{
					{ "action", "getsave" },
					{ "id", TeamId.ToString() }
				}
			);

			string DownloadedData = WebServices.GetResponseString(Request);

			string[] Lines = DownloadedData.Split('\n');
			LevelsInfo = new LevelStats[Lines.Length];
			for (int i = 0; i < LevelsInfo.Length; i++)
			{
				string[] LevelParts = Lines[i].Split('|');

				LevelsInfo[i].Available = (LevelParts[0] == "+") ? true : false;
				LevelsInfo[i].Passed = (LevelParts[1] == "+") ? true : false;
				LevelsInfo[i].Stars = int.Parse(LevelParts[2]);
				LevelsInfo[i].Minutes = int.Parse(LevelParts[3]);
				LevelsInfo[i].Seconds = int.Parse(LevelParts[4]);
			}
		}
		else
		{
			Debug.LogError("Can't load save");
		}
	}

	public void SaveToServer(int TeamId)
	{
		OnlineGameState GameState = OnlineGameState.Instance;

		if (GameState.Player != null && GameState.Partner != null)
		{
			HttpWebRequest Request = WebServices.GeneratePostRequest(
				"team",
				new System.Collections.Generic.Dictionary<string, string>()
				{
					{ "action", "getsave" },
					{ "id", TeamId.ToString() }
				}
			);

			string DownloadedData = WebServices.GetResponseString(Request);

			string[] Lines = DownloadedData.Split('\n');
			LevelsInfo = new LevelStats[Lines.Length];
			for (int i = 0; i < LevelsInfo.Length; i++)
			{
				string[] LevelParts = Lines[i].Split('|');

				LevelsInfo[i].Available = (LevelParts[0] == "+") ? true : false;
				LevelsInfo[i].Passed = (LevelParts[1] == "+") ? true : false;
				LevelsInfo[i].Stars = int.Parse(LevelParts[2]);
				LevelsInfo[i].Minutes = int.Parse(LevelParts[3]);
				LevelsInfo[i].Seconds = int.Parse(LevelParts[4]);
			}
		}
	}
}
