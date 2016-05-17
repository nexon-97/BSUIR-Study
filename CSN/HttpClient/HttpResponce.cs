using System;
using System.Collections.Generic;
using System.Text;

namespace Nexon
{
	public class HttpResponce
	{
        public Dictionary<string, string> ResponceValues;
        public HttpContent AttachedContent;
		public byte [] RawResponce;

		public HttpResponce()
		{
			ResponceValues = new Dictionary<string, string>();
		}

		public HttpResponce(byte [] RawResponce)
		{
			ResponceValues = new Dictionary<string, string>();
			Parse(RawResponce);
		}

		public void Parse(byte [] RawResponce)
		{
			this.RawResponce = RawResponce;

            string ResponceText = Encoding.ASCII.GetString(RawResponce);
            int SeparatorIndex = ResponceText.IndexOf("\r\n\r\n");

            if (SeparatorIndex != -1)
            {
                string HeaderPart = ResponceText.Substring(0, SeparatorIndex);

                string [] Separator = new string [] { "\r\n" };
                string[] HeaderLines = HeaderPart.Split(Separator, System.StringSplitOptions.RemoveEmptyEntries);

                // Fill header pairs dictionary
                foreach (var Line in HeaderLines)
                {
                    int SeparatorPos = Line.IndexOf(':');
                    if (SeparatorPos != -1)
                    {
                        string Key = Line.Substring(0, SeparatorPos).Trim();
                        string Value = Line.Substring(SeparatorPos + 1).Trim();

                        if (ResponceValues.ContainsKey(Key))
                        {
                            ResponceValues[Key] = string.Format("{0}; {1}", ResponceValues[Key], Value);
                        }
                        else
                        {
                            ResponceValues.Add(Key, Value);
                        }
                    }
                }

                FillContent(2 + SeparatorIndex + Separator[0].Length);
            }
            else
            {
                FillContent(0);
            }
		}

        protected void FillContent(int ContentBegin)
        {
            int ContentLength = 0;
            if (ResponceValues.ContainsKey("Content-Length"))
            {
                bool ParseResult = int.TryParse(ResponceValues["Content-Length"], out ContentLength);

                if (ParseResult)
                {
                    byte [] Content = new byte[ContentLength];
                    Array.Copy(RawResponce, ContentBegin, Content, 0, ContentLength);

                    AttachedContent = new HttpContent(Content, HttpContent.ContentType.PlainText, Encoding.UTF8);
                }
            }
        }

        public override string ToString()
		{
            return (AttachedContent != null) ? AttachedContent.StringRepresentation : "[EMPTY RESPONSE]";
		}
	}
}
