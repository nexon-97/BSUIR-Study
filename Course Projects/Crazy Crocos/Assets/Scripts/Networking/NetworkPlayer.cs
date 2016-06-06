using System.IO;
using System.Net;
using System.Collections.Generic;

public class NetworkPlayer
{
	#region Constants
	const int Undefined = -1;
	const string DefaultNickname = "Guest";
	#endregion

	#region Fields
	private string _Nickname;
	private string _PassHash;
	#endregion

	#region Properties
	public int Id
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

	public bool RestoreFromCache()
	{
		// Deserialize from cache
		string CachedPlayerName = GetCachedPlayerName();
		if (CachedPlayerName != null)
		{
			// Try to find player description in players folder
		}

		// Validate and reset defaults on error
		if (IsValid())
		{
			return true;
		}
		else
		{
			ResetDefaults();
			return false;
		}
	}

	private string GetCachedPlayerName()
	{
		const string CachePath = @"Data\net_cache.dat";
		if (File.Exists(CachePath))
		{
			StreamReader FileReader = new StreamReader(new FileStream(CachePath, FileMode.Open, FileAccess.Read));
			string Name = FileReader.ReadLine();
			FileReader.Close();

			return Name;
		}

		return null;
	}

	// Make server validation
	public bool IsValid()
	{
		return false;
	}

	public bool LogIn(string Login, string Password)
	{
		WebRequest LogInRequest = NetworkController.Instance.GeneratePostRequest(
			"login",
			new Dictionary<string, string>()
			{
				{ "login", Login },
				{ "password", Password }
			}
		);

		string Response = NetworkController.Instance.GetResponseString(LogInRequest).Trim();
		if (Response.IndexOf("OK") == 0)
		{
			string IdPart = Response.Substring(Response.IndexOf(":") + 1).Trim();
			Id = int.Parse(IdPart);
			_Nickname = Login;

			return true;
		}

		Id = Undefined;
		return false;
	}

	public void LogOut()
	{
		Id = Undefined;
	}
}
