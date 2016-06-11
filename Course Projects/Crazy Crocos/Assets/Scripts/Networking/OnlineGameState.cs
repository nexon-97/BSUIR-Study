using Nexon;
using UnityEngine;

public sealed class OnlineGameState
{
	#region Singleton pattern part
	private static OnlineGameState _Instance;

	private OnlineGameState()
	{
		Init();
	}

	public static OnlineGameState Instance
	{
		get
		{
			if (_Instance == null)
			{
				_Instance = new OnlineGameState();
			}

			return _Instance;
		}
	}
	#endregion

	#region Fields
	private NetworkPlayer _Player;
	private NetworkPlayer _Partner;
	private NetworkTeam _Team;
	#endregion

	#region Properties
	public bool LoggedIn
	{
		get
		{
			return (_Player != null);
		}
	}
	
	public bool PartnerConnected
	{
		get
		{
			return (_Partner != null);
		}
	}
	
	public NetworkPlayer Player
	{
		get
		{
			return _Player;
		}
	}

	public NetworkPlayer Partner
	{
		get
		{
			return _Partner;
		}
		set
		{
			_Partner = value;
		}
	}

	public NetworkTeam Team
	{
		get
		{
			return _Team;
		}
	}

	public bool DataLoaded
	{
		get
		{
			return (_Player != null && _Partner != null);
		}
	}

	public PlayerController PartnerController
	{
		get; set;
	}
	#endregion

	private void Init()
	{
		_Player = new NetworkPlayer();
	}

	public bool Authenticate(string Login, string Password)
	{
		NetworkPlayer TempPlayer = new NetworkPlayer();
		bool LoginSucceeded = _Player.LogIn(Login, Password);

		if (LoginSucceeded)
		{
			_Player = TempPlayer;
			_Player.StartSessions();
		}

		return LoginSucceeded;
	}

	public void ConnectPartner(int PartnerId, bool IsResponse)
	{
		_Partner = new NetworkPlayer();
		if (_Partner.LoadPartnerData(PartnerId))
		{
			LoadTeam();

			Session ActiveSession = _Player.ActiveSession;
			if (ActiveSession != null)
			{
				ActiveSession.Context.ConnectToPartner(_Partner.ActiveSession, IsResponse);
			}
		}
	}

	public void LoadTeam()
	{
		_Team = new NetworkTeam(_Player.Id, _Partner.Id);
		_Team.DownloadSave();
	}

	public void SendTCPMessageToPartner(TCPMessage Message)
	{
		if (_Player != null && _Player.ActiveSession != null)
		{
			SessionSync Context = _Player.ActiveSession.Context;
			Context.SendTCPMessage(Message);
		}
	}

	public void UpdatePartnerPlayerState(Vector3 position, Vector2 velocity)
	{
		if (PartnerController != null)
		{
			PartnerController.RegisterNetworkUpdate(position, velocity);
		}
	}
}
