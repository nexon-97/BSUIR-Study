using System.Net;
using UnityEngine;

public class NetworkTeam
{
	public int Id;
	public int [] Users;
	public GameSave Save;

	public NetworkTeam(int User1, int User2)
	{
		Users = new int[2] { User1, User2 };
		CreateOnServer();

		Save = new GameSave();
	}

	public void CreateOnServer()
	{
		HttpWebRequest Request = WebServices.GeneratePostRequest(
			"team",
			new System.Collections.Generic.Dictionary<string, string>()
			{
				{ "action", "create" },
				{ "user1", Users[0].ToString() },
				{ "user2", Users[1].ToString() }
			}
		);

		string TeamData = WebServices.GetResponseString(Request);
		if (TeamData.IndexOf("OK") == 0)
		{
			string TeamIdString = TeamData.Substring(TeamData.IndexOf(":") + 1).Trim();
			Id = int.Parse(TeamIdString);
		}
	}

	public void DownloadSave()
	{
		Save.LoadFromServer(Id);
	}

	public void UploadSave()
	{

	}
}
