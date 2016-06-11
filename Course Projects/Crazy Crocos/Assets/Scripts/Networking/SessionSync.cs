using System.Net;
using System.Net.Sockets;
using System;
using System.Text;
using UnityEngine;
using Nexon;

public sealed class SessionSync
{
	#region Fields
	private IPAddress _IP;

	private TcpListener _TCPServer;
	private TcpClient _TCPClient;

	private AsyncMessageProcessor _MessageProcessor;

	private int _TCPServerPort;
	private bool _ConnectionActive;

	private static byte[] buffer = new byte[1024];
	#endregion

	#region Properties
	public TcpListener TCPServerSocket
	{
		get
		{
			return _TCPServer;
		}
	}

	public TcpClient TCPClientSocket
	{
		get
		{
			return _TCPClient;
		}
	}

	public bool ConnectionActive
	{
		get
		{
			return _ConnectionActive;
		}
	}

	public TcpClient ConnectedPartner
	{
		get; set;
	}

	public int TCPPort
	{
		get
		{
			return _TCPServerPort;
		}
		set
		{
			if (!_ConnectionActive)
			{
				_TCPServerPort = value;
			}
		}
	}
	#endregion

	public SessionSync(IPAddress IP)
	{
		_IP = IP;
		_ConnectionActive = false;
	}

	public void Init()
	{
		InitSockets();
	}

	private void InitSockets()
	{
		_TCPServer = new TcpListener(_IP, 0);
		try
		{
			_TCPServer.Start();
		}
		catch (Exception)
		{
			Debug.Log("Failed to establish TCP Server");
			return;
		}

		// Determine server listener port
		IPEndPoint ServerEndPoint = _TCPServer.Server.LocalEndPoint as IPEndPoint;
		if (ServerEndPoint != null)
		{
			_TCPServerPort = ServerEndPoint.Port;
		}
		_ConnectionActive = true;

		_TCPServer.BeginAcceptTcpClient(new AsyncCallback(PartnerConnected), null);
	}

	public bool ConnectToPartner(Session PartnerSession, bool IsResponse)
	{
		_TCPClient = new TcpClient();
		_TCPClient.Connect(PartnerSession.IP, PartnerSession.TCPServerPort);

		if (!IsResponse)
		{
			// Notify partner, that he should accept player connection
			SendTCPCommand(TCPCommand.PartnerConnectRequested, OnlineGameState.Instance.Player.Id.ToString());

			// Open waiting message...
		}

		return false;
	}

	// Callback, when partner has been connected
	public void PartnerConnected(IAsyncResult Result)
	{
		TcpClient Client = TCPServerSocket.EndAcceptTcpClient(Result);
		_MessageProcessor = new AsyncMessageProcessor(Client);

		_MessageProcessor.StartMessageReceiveLoop();
	}

	public void SendTCPCommand(TCPCommand Command, string data = null)
	{
		try
		{
			NetworkStream DataStream = _TCPClient.GetStream();

			TCPMessage Message = new TCPMessage(Command, data);
			byte[] Bytes = Encoding.UTF8.GetBytes(Message.ToString());
			DataStream.Write(Bytes, 0, Bytes.Length);

			//Debug.LogError("Command sent: " + Command.ToString());
		}
		catch (Exception e)
		{
			Debug.LogError("Command not sent. Reason: " + e.Message);
		}
	}

	public void SendTCPMessage(TCPMessage Message)
	{
		try
		{
			NetworkStream DataStream = _TCPClient.GetStream();

			byte[] Bytes = Encoding.UTF8.GetBytes(Message.ToString());
			DataStream.Write(Bytes, 0, Bytes.Length);

			//Debug.LogError("Command sent: " + Message.Command.ToString());
		}
		catch (Exception e)
		{
			Debug.LogError("Command not sent. Reason: " + e.Message);
		}
	}
}
