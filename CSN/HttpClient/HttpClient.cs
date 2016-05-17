using System.Net.Sockets;
using System.Text;
using System;
using System.Windows;

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

		public bool ConnectToServer(string Address)
		{
			ClientSocket = new TcpClient();
            try
            {
                ClientSocket.Connect(Address, HttpDefaultPort);
            }
			catch (Exception)
            {
                MessageBox.Show("Failed to connect to host!", "Connection Error", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

			if (ClientSocket.Connected)
			{
				HttpStream = ClientSocket.GetStream();
                return true;
			}

            return false;
		}

		public HttpResponse SendRequest(HttpRequest Request)
		{
			if (HttpStream != null)
			{
				string RequestText = Request.ToString();
				HttpStream.Write(Encoding.ASCII.GetBytes(RequestText), 0, RequestText.Length);

                const int BufferSize = 65536;
                byte[] ReadBuffer = new byte[BufferSize];
                HttpStream.Read(ReadBuffer, 0, BufferSize);

                return new HttpResponse(ReadBuffer);
			}

			return null;
		}
	}
}
