using System.Text;
using System.Collections.Generic;

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
        public Dictionary<string, string> RequestHeaders;

		public string Host;
		public string Page;
        public HttpContent AttachedContent;

        public HttpRequest(RequestMethod RequestMethod)
        {
            RequestHeaders = new Dictionary<string, string>();
            Method = RequestMethod;
        }

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

        public void AddHeader(string Key, string Value)
        {
            if (RequestHeaders.ContainsKey(Key))
            {
                RequestHeaders[Key] += Value;
            }
            else
            {
                RequestHeaders.Add(Key, Value);
            }
        }

		public override string ToString()
		{
			StringBuilder HeaderBuilder = new StringBuilder();
            foreach (var Item in RequestHeaders)
            {
                HeaderBuilder.AppendFormat("{0}: {1}\n", Item.Key, Item.Value);
            }

            if (AttachedContent == null)
            {
                AttachedContent = new HttpContent(null);
            }

			string RequestText = string.Format(
				"{0} /{1} HTTP/1.1\nHost: {2}\nAccept: */*\nConnection: {3}\n{4}\n{5}",
				GetRequestMethodString(Method),
				Page,
				Host,
				GetConnectionTypeString(ConnectionType),
                HeaderBuilder.ToString(),
                AttachedContent._Data
			);

			return RequestText;
		}
	}
}
