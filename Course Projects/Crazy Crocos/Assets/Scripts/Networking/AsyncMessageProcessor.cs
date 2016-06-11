using System;
using System.Net.Sockets;
using System.Text;
using UnityEngine;
using Nexon;

public class AsyncMessageProcessor
{
	private const int BufferSize = 512;

	private TcpClient ClientSocket;
	private NetworkStream DataStream;
	private byte[] buffer;

	public AsyncMessageProcessor(TcpClient Client)
	{
		ClientSocket = Client;
	}

	public void StartMessageReceiveLoop()
	{
		if (ClientSocket != null)
		{
			DataStream = ClientSocket.GetStream();
			buffer = new byte[BufferSize];

			DataStream.BeginRead(buffer, 0, buffer.Length, MessageReceiveLoop, null);
		}
	}

	private void MessageReceiveLoop(IAsyncResult Result)
	{
		int BytesRead = DataStream.EndRead(Result);

		if (BytesRead == 0)
		{
			ClientSocket.Close();

			Debug.LogError("Partner disconnected");
		}
		else
		{
			TCPMessage ReceivedMessage = new TCPMessage(Encoding.UTF8.GetString(buffer));
			TCPProtocol.Instance.ProcessCommand(ReceivedMessage.Command, ReceivedMessage.AttachedData);

			DataStream.BeginRead(buffer, 0, buffer.Length, MessageReceiveLoop, null);
		}
	}
}
