using System.IO;
using System.Net;
using System.Collections.Generic;
using UnityEngine;

public class NetworkPlayer
{
	#region Constants
	const int Undefined = -1;
	const string DefaultNickname = "Guest";
	#endregion

	#region Fields
	private string _Nickname;
	private string _PassHash;
	private Session[] _Sessions;
	#endregion

	#region Properties
	public int Id
	{
		get; set;
	}

	public int CrocoIndex
	{
		get; set;
	}

	public int OrderInTeam
	{
		get; set;
	}

	public bool Authorized
	{
		get
		{
			return (Id != Undefined);
		}
	}

	public string Nickname
	{
		get
		{
			return _Nickname;
		}
	}

	public string PasswordHash
	{
		get
		{
			return _PassHash;
		}
	}

	public Session ActiveSession
	{
		get
		{
			return (_Sessions.Length > 0) ? _Sessions[0] : null;
		}
	}
	#endregion

	#region Constructors
	public NetworkPlayer()
	{
		ResetDefaults();
	}
	#endregion

	private void ResetDefaults()
	{
		Id = Undefined;
		_Nickname = DefaultNickname;
		_PassHash = string.Empty;
	}

	public bool LogIn(string Login, string Password)
	{
		HttpWebRequest LogInRequest = WebServices.GeneratePostRequest(
			"login",
			new Dictionary<string, string>()
			{
				{ "login", Login },
				{ "password", Password }
			}
		);

		Debug.Log("Request generated");

		string Response = WebServices.GetResponseString(LogInRequest).Trim();
		if (Response.IndexOf("OK") == 0)
		{
			string IdPart = Response.Substring(Response.IndexOf(":") + 1).Trim();
			Id = int.Parse(IdPart);
			_Nickname = Login;

			HttpWebRequest LoadDataRequest = WebServices.GeneratePostRequest(
				"list",
				new Dictionary<string, string>()
				{
					{ "user_id", Id.ToString() }
				}
			);
			Response = WebServices.GetResponseString(LoadDataRequest).Trim();

			string[] ParsedData = Response.Split('|');
			CrocoIndex = int.Parse(ParsedData[2]);

			return true;
		}

		Id = Undefined;
		return false;
	}

	public void LogOut()
	{
		Id = Undefined;
	}

	public bool LoadPartnerData(int PartnerId)
	{
		HttpWebRequest LogInRequest = WebServices.GeneratePostRequest(
			"list",
			new Dictionary<string, string>()
			{
				{ "user_id", PartnerId.ToString() }
			}
		);

		string Response = WebServices.GetResponseString(LogInRequest).Trim();
		if (!Response.Equals("FAIL"))
		{
			string[] PartnerData = Response.Split('|');

			Id = int.Parse(PartnerData[0]);
			_Nickname = PartnerData[1];
			CrocoIndex = int.Parse(PartnerData[2]);

			LoadPartnerSessionsInfo();

			return true;
		}

		Id = Undefined;
		return false;
	}

	public void LoadPartnerSessionsInfo()
	{
		Session TempSession = new Session();
		if (TempSession.FindByUserId(Id))
		{
			_Sessions = new Session[1];
			_Sessions[0] = TempSession;
		}
	}

	public void StartSessions()
	{
		if (Authorized)
		{
			// Load IP info
			IPAddress[] IPs = NetworkController.Instance.GetNetworkIPAddresses();
			_Sessions = new Session[IPs.Length];

			int i = 0;
			foreach (var IP in IPs)
			{
				// Start session on each ip
				_Sessions[i] = new Session();
				_Sessions[i].IP = IP;

				bool Created = _Sessions[i].Create(this);
				if (Created)
				{
					Debug.Log(string.Format("{0} started session on {1}:{2}", Nickname, IP, _Sessions[i].TCPServerPort));
				}

				i++;
			}
		}
	}

	public void EndSessions()
	{
		if (Authorized)
		{
			foreach (var Session in _Sessions)
			{
				Session.Drop();
			}
		}
	}
}
