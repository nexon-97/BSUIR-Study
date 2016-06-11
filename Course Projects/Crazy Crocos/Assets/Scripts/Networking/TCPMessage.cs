using UnityEngine;

namespace Nexon
{
	public class TCPMessage
	{
		public TCPCommand Command;
		public string AttachedData;

		public TCPMessage(TCPCommand Command, string AttachedData = null)
		{
			this.Command = Command;
			this.AttachedData = AttachedData;
		}

		public TCPMessage(string RawMessage)
		{
			Parse(RawMessage);
		}

		public void Parse(string RawMessage)
		{
			string[] MessageParts = RawMessage.Split('|');

			Command = (TCPCommand) int.Parse(MessageParts[0].Trim());
			int DataLength = int.Parse(MessageParts[1].Trim());
			AttachedData = MessageParts[2].Trim();
		}

		public override string ToString()
		{
			int CommandCode = (int)Command;
			if (AttachedData == null)
			{
				AttachedData = string.Empty;
			}

			return string.Format("{0}|{1}|{2}", CommandCode.ToString(), AttachedData.Length, AttachedData);
		}
	}
}
