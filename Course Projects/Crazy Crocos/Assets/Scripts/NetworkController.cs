using System.Net;
using System.IO;
using System.Text;
using UnityEngine;

public sealed class NetworkController
{
	#region Singleton pattern part
	private static NetworkController instance;

	private NetworkController()
	{
		Init();
	}

	public static NetworkController Instance
	{
		get
		{
			if (instance == null)
			{
				instance = new NetworkController();
			}

			return instance;
		}
	}
	#endregion

	private void Init()
	{
		Session TestSession = LoadSession(1);

		if (TestSession != null)
		{
			Debug.Log(string.Format("{0}; {1}; {2}; {3}", TestSession.Id, TestSession.User.ToString(), TestSession.Address.ToString(), TestSession.LastActivity.ToString()));
		}
		else
		{
			Debug.Log("Fuck!");
		}
	}

	public Session LoadSession(int SessionId)
	{
		HttpWebRequest Request = WebRequest.Create(@"http://nexonlab.hol.es/game_server/session.php") as HttpWebRequest;
		Request.Method = "POST";
		Request.ContentType = "text/plain";

		string AttachedPostContent = string.Format(@"action=get&id={0}", SessionId);
		byte[] ContentBytes = Encoding.UTF8.GetBytes(AttachedPostContent);
		Request.ContentLength = ContentBytes.Length;
		using (BinaryWriter RequestWriter = new BinaryWriter(Request.GetRequestStream()))
		{
			RequestWriter.Write(ContentBytes);
		}

		HttpWebResponse Response = Request.GetResponse() as HttpWebResponse;
		string ResponseData;
		string[] ParsedResponse;
		using (StreamReader ResponseReader = new StreamReader(Response.GetResponseStream()))
		{
			ResponseData = ResponseReader.ReadToEnd();
		}

		Debug.Log(ResponseData);
		return null;
		/*if (ResponseData.Equals("NOT FOUND"))
		{
			return null;
		}
		else
		{
			ParsedResponse = ResponseData.Split('|');
			return new Session(int.Parse(ParsedResponse[0]), int.Parse(ParsedResponse[1]), ParsedResponse[2], ParsedResponse[3]);
		}*/
	}
}
