using System.Net;
using System;
using System.Globalization;
using System.Collections.Generic;

public class Session
{
	public int Id;
	public NetworkPlayer User;
	public IPAddress IP;
	public DateTime LastActivity;

	private SessionSync Sync;

	public int TCPServerPort
	{
		get
		{
			return (Sync != null) ? Sync.TCPServerPort : -1;
		}
	}

	public int UDPPort
	{
		get
		{
			return (Sync != null) ? Sync.UDPPort : -1;
		}
	}


	public bool Create()
	{
		User = NetworkController.Instance.ActivePlayer;

		if (User != null)
		{
			Sync = new SessionSync(IP);
			Sync.Init();

			if (Sync.ConnectionActive)
			{
				NetworkController Network = NetworkController.Instance;

				WebRequest Request = Network.GeneratePostRequest
				(
					"session",
					new Dictionary<string, string>()
					{
						{ "action", "create" },
						{ "user_id", User.Id.ToString() },
						{ "address", IP.ToString() },
						{ "tcp", TCPServerPort.ToString() },
						{ "udp", UDPPort.ToString() }
					}
				);

				string Response = Network.GetResponseString(Request);
				if (Response.IndexOf("OK") == 0)
				{
					string SessionIdString = Response.Substring(Response.IndexOf(":") + 1).Trim();
					Id = int.Parse(SessionIdString);

					return true;
				}
				else
				{
					Id = -1;
				}
			}
		}

		return false;
	}

	public bool UpdateOnServer()
	{
		WebRequest Request = NetworkController.Instance.GeneratePostRequest(
			"session",
			new Dictionary<string, string>()
			{
				{ "action"	, "update"		},
				{ "id"		, Id.ToString()	}
			}
		);

		string Response = NetworkController.Instance.GetResponseString(Request);
		return (Response.Equals("OK"));
	}

	public bool LoadFromServer(int Id)
	{
		WebRequest Request = NetworkController.Instance.GeneratePostRequest(
			"session",
			new Dictionary<string, string>()
			{
				{ "action"  , "get"      },
				{ "id"      , Id.ToString() }
			}
		);

		string Response = NetworkController.Instance.GetResponseString(Request).Trim();
		if (!Response.Equals("NOT FOUND"))
		{
			string[] SessionParts = Response.Split('|');
			
			Id = int.Parse(SessionParts[0]);
			User = NetworkController.Instance.ActivePlayer;
			IP = IPAddress.Parse(SessionParts[2]);

			Sync = new SessionSync(IP);
			Sync.TCPServerPort = int.Parse(SessionParts[3]);
			Sync.UDPPort = int.Parse(SessionParts[4]);

			const string DateFormat = "yyyy-MM-dd HH:mm:ss";
			LastActivity = DateTime.ParseExact(SessionParts[5], DateFormat, CultureInfo.InvariantCulture);

			return true;
		}

		return false;
	}
}
