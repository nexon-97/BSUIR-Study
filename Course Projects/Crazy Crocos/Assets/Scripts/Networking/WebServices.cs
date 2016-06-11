using System.Net;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System;
using UnityEngine;

public sealed class WebServices
{
	const string ServicesPath = "http://nexonlab.hol.es/game_server/";
	const int DefaultTimeout = 5000;

	public static HttpWebRequest GeneratePostRequest(string ServiceName, Dictionary<string, string> Params)
	{
		HttpWebRequest Request = WebRequest.Create(string.Format("{0}{1}.php", ServicesPath, ServiceName)) as HttpWebRequest;
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
		Request.ReadWriteTimeout = DefaultTimeout;

		// Write request data
		Stream RequestStream = Request.GetRequestStream();
		RequestStream.Write(DataBytes, 0, DataBytes.Length);
		RequestStream.Close();

		return Request;
	}

	public static string GetResponseString(HttpWebRequest Request)
	{
		try
		{
			HttpWebResponse Response = Request.GetResponse() as HttpWebResponse;
			return new StreamReader(Response.GetResponseStream()).ReadToEnd().Trim();
		}
		catch (Exception)
		{
			Debug.LogError("Failed to send web service request!");
			return null;
		}
	}

	public static byte[] GetResponseData(HttpWebRequest Request)
	{
		try
		{
			HttpWebResponse Response = Request.GetResponse() as HttpWebResponse;
			return new BinaryReader(Response.GetResponseStream()).ReadBytes((int)Response.ContentLength);
		}
		catch (Exception)
		{
			Debug.LogError("Failed to send web service request!");
			return null;
		}
	}
}

