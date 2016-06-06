using System.Net;
using System.Net.Sockets;
using System;
using UnityEngine;
using Nexon;

public sealed class SessionSync
{
	#region Fields
	private TcpListener _TCPServer;
	private TcpClient _TCPClient;
	private UdpClient _UDPClient;

	private int _TCPServerPort;
	private int _UDPHostPort;

	private bool _ConnectionActive;

	private IPAddress _IP;
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

	public int TCPServerPort
	{
		get { return _TCPServerPort; }
		set
		{
			if (!ConnectionActive)
			{
				_TCPServerPort = value;
			}
		}
	}

	public int UDPPort
	{
		get { return _UDPHostPort; }
		set
		{
			if (!ConnectionActive)
			{
				_UDPHostPort = value;
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
	}

	public TCPRequest CreateRequest(TCPCommand Command, byte[] Data)
	{
		return new TCPRequest(Command, Data);
	}
}
