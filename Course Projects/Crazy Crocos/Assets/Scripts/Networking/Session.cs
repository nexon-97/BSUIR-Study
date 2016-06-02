using System.Net;
using System;
using System.Globalization;
using System.Collections.Generic;

public class Session
{
	public int Id;
	public NetworkPlayer User;
	public IPAddress Address;
	public int Port;
	public DateTime LastActivity;

	public Session(int Id, int UserId, string NetworkAddress, string LastActivityTimestamp)
	{
		this.Id = Id;
		this.User = new NetworkPlayer();

		string[] NetworkAddressParts = NetworkAddress.Split(':');
		string[] IPParts = NetworkAddressParts[0].Split('.');
		byte[] IPBytes = new byte[4];
		for (int i = 0; i < IPBytes.Length; i++)
		{
			IPBytes[i] = byte.Parse(IPParts[i]);
		}

		Address = new IPAddress(IPBytes);
		Port = int.Parse(NetworkAddressParts[1]);

		string DateFormat = @"yyyy-MM-dd HH:mm:ss";
		LastActivity = DateTime.ParseExact(LastActivityTimestamp, DateFormat, CultureInfo.InvariantCulture);
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
}
