using System.Text;

namespace Nexon
{
	public enum RequestMethod
	{
		Get,
		Post,
		Put,
		Delete
	}

	public enum ConnectionType
	{
		KeepAlive,
		Closed
	}

	public class HttpRequest
	{
		public RequestMethod Method;
		public ConnectionType ConnectionType;

		public string Host;
		public string Page;

		public static string GetRequestMethodString(RequestMethod Method)
		{
			switch (Method)
			{
				case RequestMethod.Get:
					return "GET";
				case RequestMethod.Post:
					return "POST";
				case RequestMethod.Put:
					return "PUT";
				case RequestMethod.Delete:
				default:
					return "DELETE";
			}
		}

		public static string GetConnectionTypeString(ConnectionType Type)
		{
			switch (Type)
			{
				case ConnectionType.KeepAlive:
					return "Keep-Alive";
				case ConnectionType.Closed:
				default:
					return "Closed";
			}
		}

		public override string ToString()
		{
			StringBuilder ResultBuilder = new StringBuilder();

			string RequestText = string.Format(
				"{0} /{1} HTTP/1.1\nHost: {2}\nAccept: */*\nConnection: {3}\n\n",
				GetRequestMethodString(Method),
				Page,
				Host,
				GetConnectionTypeString(ConnectionType)
			);

			return RequestText;
		}
	}
}
