using System;
using System.Net;
using System.Net.NetworkInformation;
using System.Net.Sockets;
using UnityEngine;
using System.Collections.Generic;
using Nexon;

public sealed class NetworkController
{
	#region Singleton pattern part
	private static NetworkController instance;

	private NetworkController()
	{
		
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
	
	public IPAddress[] GetNetworkIPAddresses()
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

	public string[] LoadNetworkPartners()
	{
		OnlineGameState GameState = OnlineGameState.Instance;
		if (GameState.Player != null)
		{
			HttpWebRequest Request = WebServices.GeneratePostRequest
			(
				"list",
				new Dictionary<string, string>()
				{
					{ "sender", OnlineGameState.Instance.Player.Id.ToString() }
				}
			);

			return WebServices.GetResponseString(Request).Split('\n');
		}

		return null;
	}
}
