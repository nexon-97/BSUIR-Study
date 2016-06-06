namespace Nexon
{
	public class TCPRequest
	{
		public TCPCommand Command;
		public byte[] AttachedData;

		public TCPRequest(TCPCommand Command, byte[] AttachedData = null)
		{
			this.Command = Command;
			this.AttachedData = AttachedData;
		}

		public TCPResponse GetResponse()
		{
			TCPResponse Response = new TCPResponse();

			return Response;
		}
	}
}
