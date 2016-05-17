using System.Collections.Generic;

namespace Nexon
{
	public class HttpResponce
	{
		protected Dictionary<string, string> ResponceValues;
		public string RawResponce;

		public HttpResponce()
		{
			ResponceValues = new Dictionary<string, string>();
		}

		public HttpResponce(string RawResponce)
		{
			ResponceValues = new Dictionary<string, string>();
			Parse(RawResponce);
		}

		public void Parse(string RawResponce)
		{
			this.RawResponce = RawResponce;
			string [] ResponceLines = RawResponce.Split('\n');
			foreach (var Line in ResponceLines)
			{
				int SeparatorPos = Line.IndexOf(':');
				if (SeparatorPos != -1)
				{
					string Key = Line.Substring(0, SeparatorPos);
					string Value = Line.Substring(SeparatorPos + 1);
					ResponceValues.Add(Key.Trim(), Value.Trim());
				}
			}
		}

		public override string ToString()
		{
			return RawResponce;
		}
	}
}
