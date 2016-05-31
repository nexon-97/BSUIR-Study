using System.Net;
using System.Text;
using System.IO;
using UnityEngine;

public class NetworkManager
{
	#region Singleton pattern
	private static NetworkManager _instance;

	private NetworkManager()
	{
		Init();
	}

	public static NetworkManager Instance
	{
		get
		{
			if (_instance == null)
			{
				_instance = new NetworkManager();
			}

			return _instance;
		}
	}
	#endregion

	private void Init()
	{
		HttpWebRequest Request = WebRequest.Create("http://nexonlab.hol.es/game_server/register.php") as HttpWebRequest;

		string postData = "login=mamka";
		byte [] data = Encoding.UTF8.GetBytes(postData);

		Request.Method = "POST";
		Request.ContentType = "application/x-www-form-urlencoded";
		Request.ContentLength = data.Length;

		using (var stream = Request.GetRequestStream())
		{
			stream.Write(data, 0, data.Length);
		}

		HttpWebResponse Response = Request.GetResponse() as HttpWebResponse;
		string ResponseString = new StreamReader(Response.GetResponseStream()).ReadToEnd();

		Debug.Log(ResponseString);
	}

	/*public OnlineSession InitSession()
	{
		OnlineSession Session = new OnlineSession(1);
		return Session;
	}*/

	public void UpdateSession()
	{

	}

	public void DestroySession()
	{

	}
}
