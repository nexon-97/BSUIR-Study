using System.Net;
using System.Net.NetworkInformation;
using System.Net.Sockets;
using System.IO;
using System.Text;
using UnityEngine;
using System.Collections.Generic;

public sealed class NetworkController
{
	const string ServicesPath = "http://nexonlab.hol.es/game_server/";

	public Session ActiveSession
	{
		get; set;
	}

	public NetworkPlayer ActivePlayer
	{
		get; set;
	}

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
		ActivePlayer = new NetworkPlayer();
		ActivePlayer.RestoreFromCache();
		//ActivePlayer.LogIn("Nexon", "test");

		if (ActivePlayer.Authorized)
		{
			// Load IP info
			IPAddress[] IPs = GetClientIPAddresses();
			foreach (var IP in IPs)
			{
				// Start session on each ip
				Debug.Log("Start session on " + IP.ToString());

				StartSession(1, IP.ToString() + ":25546");
			}
		}
	}

	public Session LoadSession(int SessionId)
	{
		// Form session info GET request
		WebRequest Request = GeneratePostRequest(
			"session",
			new Dictionary<string, string>()
			{
				{ "action", "get" },
				{ "id", SessionId.ToString() }
			}
		);

		// Parse response
		string Response = GetResponseString(Request);
		if (!Response.Equals("NOT FOUND"))
		{
			string[] ParsedResponse = Response.Split('|');

			if (ParsedResponse.Length == 4)
			{
				return new Session(int.Parse(ParsedResponse[0]), int.Parse(ParsedResponse[1]), ParsedResponse[2], ParsedResponse[3]);
			}
			else
			{
				Debug.LogError("Invalid session response data");
			}
		}

		return null;
	}

	public Session StartSession(int UserId, string NetworkAddress)
	{

		// Form session CREATE request
		WebRequest Request = GeneratePostRequest(
			"session",
			new Dictionary<string, string>()
			{
				{ "action", "create" },
				{ "user_id", UserId.ToString() },
				{ "address", NetworkAddress }
			}
		);

		// Parse response
		string Response = GetResponseString(Request);

		int SessionId;
		if (int.TryParse(Response, out SessionId))
		{
			ActiveSession = LoadSession(SessionId);
			return ActiveSession;
		}
		else
		{
			Debug.LogError("Failed to start new session!");
		}

		return null;
	}

	public WebRequest GeneratePostRequest(string ServiceName, Dictionary<string, string> Params)
	{
		WebRequest Request = WebRequest.Create( string.Format("{0}{1}.php", ServicesPath, ServiceName) );
		Request.Method = "POST";

		// Convert dictionary values to post format string
		int ParamsWritten = 0;
		string Data = string.Empty;
		foreach (var Pair in Params)
		{
			Data += string.Format("{0}{1}={2}", ((ParamsWritten > 0) ? "&" : ""), Pair.Key, Pair.Value);
			ParamsWritten++;
		}
		byte[] DataBytes = Encoding.UTF8.GetBytes(Data);

		Request.ContentType = "application/x-www-form-urlencoded";
		Request.ContentLength = DataBytes.Length;

		// Write request data
		Stream RequestStream = Request.GetRequestStream();
		RequestStream.Write(DataBytes, 0, DataBytes.Length);
		RequestStream.Close();

		return Request;
	}

	public string GetResponseString(WebRequest Request)
	{
		WebResponse Response = Request.GetResponse();
		return new StreamReader(Response.GetResponseStream()).ReadToEnd().Trim();
	}

	public byte[] GetResponseData(WebRequest Request)
	{
		WebResponse Response = Request.GetResponse();
		return new BinaryReader(Response.GetResponseStream()).ReadBytes((int) Response.ContentLength);
	}

	public IPAddress[] GetClientIPAddresses()
	{
		List<IPAddress> Addresses = new List<IPAddress>();

		NetworkInterface[] interfaces = NetworkInterface.GetAllNetworkInterfaces();
		foreach (NetworkInterface Adapter in interfaces)
		{
			IPInterfaceProperties IpProps = Adapter.GetIPProperties();

			foreach (var IP in IpProps.UnicastAddresses)
			{
				if ((Adapter.OperationalStatus == OperationalStatus.Up)
					 && (IP.Address.AddressFamily == AddressFamily.InterNetwork))
				{
					// Filter only IPv4 addresses
					if (IP.Address.GetAddressBytes().Length == 4)
					{
						Addresses.Add(IP.Address);
					}
				}
			}
		}

		return Addresses.ToArray();
	}
}
