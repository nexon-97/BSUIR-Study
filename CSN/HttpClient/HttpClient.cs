using System.Net.Sockets;
using System.Text;

namespace Nexon
{
	public class HttpClient
	{
		#region Properties
		public const int HttpDefaultPort = 80;

		protected TcpClient ClientSocket;
		protected NetworkStream HttpStream;
		#endregion

		public HttpClient()
		{
			
		}

		public void ConnectToServer(string Address)
		{
			ClientSocket = new TcpClient();
			ClientSocket.Connect(Address, HttpDefaultPort);

			if (ClientSocket.Connected)
			{
				HttpStream = ClientSocket.GetStream();

				/*string BufferString = "GET /hello.htm HTTP/1.1\nUser - Agent: Mozilla / 4.0(compatible; MSIE5.01; Windows NT)\nHost: www.tutorialspoint.com\nAccept - Language: en - us\nAccept - Encoding: gzip, deflate\nConnection: Keep-Alive\n\n";
				byte [] Bytes = Encoding.ASCII.GetBytes(BufferString);
				HttpStream.Write(Bytes, 0, BufferString.Length);

				byte[] ReadBuffer = new byte[65536];
				HttpStream.Read(ReadBuffer, 0, 65536);

				string ResponceText = Encoding.ASCII.GetString(ReadBuffer);

				int a = 0;*/
			}
		}

		public HttpResponce SendRequest(HttpRequest Request)
		{
			if (HttpStream != null)
			{
				string RequestText = Request.ToString();
				HttpStream.Write(Encoding.ASCII.GetBytes(RequestText), 0, RequestText.Length);

				byte[] ReadBuffer = new byte[65536];
				HttpStream.Read(ReadBuffer, 0, 65536);
				string ResponceText = Encoding.ASCII.GetString(ReadBuffer);

				return new HttpResponce(ResponceText);
			}

			return null;
		}
	}
}
