using System.Net;
using System;
using System.Globalization;
using System.Collections.Generic;
using Nexon;

public class Session
{
	#region Fields
	public int Id;
	public IPAddress IP;
	public DateTime LastActivity;
	public NetworkPlayer Owner;

	private SessionSync Sync;
	#endregion

	#region Properties
	public int TCPServerPort
	{
		get
		{
			return Sync.TCPPort;
		}
	}

	public SessionSync Context
	{
		get
		{
			return Sync;
		}
	}
	#endregion

	public bool Create(NetworkPlayer _Owner)
	{
		Owner = _Owner;

		if (Owner != null)
		{
			Sync = new SessionSync(IP);
			Sync.Init();

			if (Sync.ConnectionActive)
			{
				NetworkController Network = NetworkController.Instance;

				HttpWebRequest Request = WebServices.GeneratePostRequest
				(
					"session",
					new Dictionary<string, string>()
					{
						{ "action", "create" },
						{ "user_id", Owner.Id.ToString() },
						{ "address", IP.ToString() },
						{ "tcp", TCPServerPort.ToString() },
						{ "udp", "0" }
					}
				);

				string Response = WebServices.GetResponseString(Request);
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

	public bool Drop()
	{
		HttpWebRequest Request = WebServices.GeneratePostRequest(
			"session",
			new Dictionary<string, string>()
			{
				{ "action"  , "drop"        },
				{ "id"      , Id.ToString() }
			}
		);

		string Response = WebServices.GetResponseString(Request).Trim();
		return Response.Equals("OK");
	}

	public bool UpdateOnServer()
	{
		HttpWebRequest Request = WebServices.GeneratePostRequest(
			"session",
			new Dictionary<string, string>()
			{
				{ "action"	, "update"		},
				{ "id"		, Id.ToString()	}
			}
		);

		string Response = WebServices.GetResponseString(Request);
		return (Response.Equals("OK"));
	}

	public bool LoadFromServer(int Id)
	{
		HttpWebRequest Request = WebServices.GeneratePostRequest(
			"session",
			new Dictionary<string, string>()
			{
				{ "action"  , "get"      },
				{ "id"      , Id.ToString() }
			}
		);

		string Response = WebServices.GetResponseString(Request).Trim();
		if (!Response.Equals("NOT FOUND"))
		{
			string[] SessionParts = Response.Split('|');
			
			Id = int.Parse(SessionParts[0]);
			IP = IPAddress.Parse(SessionParts[2]);

			const string DateFormat = "yyyy-MM-dd HH:mm:ss";
			LastActivity = DateTime.ParseExact(SessionParts[5], DateFormat, CultureInfo.InvariantCulture);

			return true;
		}

		return false;
	}

	public bool FindByUserId(int Id)
	{
		HttpWebRequest Request = WebServices.GeneratePostRequest(
			"session",
			new Dictionary<string, string>()
			{
				{ "action" , "get"         },
				{ "user"   , Id.ToString() }
			}
		);

		string Response = WebServices.GetResponseString(Request).Trim();
		if (!Response.Equals("NOT FOUND"))
		{
			string[] SessionParts = Response.Split('|');

			Id = int.Parse(SessionParts[0]);
			IP = IPAddress.Parse(SessionParts[2]);

			Sync = new SessionSync(IP);
			Sync.TCPPort = int.Parse(SessionParts[3]);

			const string DateFormat = "yyyy-MM-dd HH:mm:ss";
			LastActivity = DateTime.ParseExact(SessionParts[5], DateFormat, CultureInfo.InvariantCulture);

			return true;
		}

		return false;
	}
}
