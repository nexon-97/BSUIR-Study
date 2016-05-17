using System.Text;

namespace Nexon
{
	public class HttpContent
	{
		public enum ContentType
		{
			Binary,
			PlainText
		}

		public ContentType _ContentType;
		public Encoding _Encoding;
		public byte[] _Data;

		#region Properties
		public string ASCIIString
		{
			get
			{
				return Encoding.ASCII.GetString(_Data);
			}
		}

		public string UTF8String
		{
			get
			{
				return Encoding.UTF8.GetString(_Data);
			}
		}

		public string StringRepresentation
		{
			get
			{
				if (_Encoding.Equals(Encoding.UTF8))
				{
					return UTF8String;
				}
				else
				{
					return ASCIIString;
				}
			}
		}
		#endregion

		public HttpContent(byte[] Data, ContentType ContentType, Encoding Encoding)
		{
			_Data = Data;
			_ContentType = ContentType;
			_Encoding = Encoding;
		}
	}
}