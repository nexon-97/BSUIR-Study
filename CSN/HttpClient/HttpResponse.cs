using System;
using System.Collections.Generic;
using System.Text;

namespace Nexon
{
	public class HttpResponse
	{
        public Dictionary<string, string> ResponseValues;
        public HttpContent AttachedContent;
		public byte [] RawResponse;
		public int ServerStateCode;
		public string ServerStateCodeDesc;

		public HttpResponse()
		{
			ResponseValues = new Dictionary<string, string>();
		}

		public HttpResponse(byte [] RawResponse)
		{
			ResponseValues = new Dictionary<string, string>();
			Parse(RawResponse);
		}

		public void Parse(byte [] RawResponse)
		{
			this.RawResponse = RawResponse;

            string ResponceText = Encoding.ASCII.GetString(RawResponse);
            int SeparatorIndex = ResponceText.IndexOf("\r\n\r\n");

            if (SeparatorIndex != -1)
            {
                string HeaderPart = ResponceText.Substring(0, SeparatorIndex);

                string [] Separator = new string [] { "\r\n" };
                string[] HeaderLines = HeaderPart.Split(Separator, System.StringSplitOptions.RemoveEmptyEntries);

				string MainInfoLine = HeaderLines[0];
				string [] MainInfo = MainInfoLine.Split(' ');
				int.TryParse(MainInfo[1], out ServerStateCode);

				ServerStateCodeDesc = String.Empty;
				for (int i = 2; i < MainInfo.Length; i++)
				{
					ServerStateCodeDesc += (MainInfo[i] + " ");
				}

				// Fill header pairs dictionary
				foreach (var Line in HeaderLines)
                {
                    int SeparatorPos = Line.IndexOf(':');
                    if (SeparatorPos != -1)
                    {
                        string Key = Line.Substring(0, SeparatorPos).Trim();
                        string Value = Line.Substring(SeparatorPos + 1).Trim();

                        if (ResponseValues.ContainsKey(Key))
                        {
							ResponseValues[Key] = string.Format("{0}; {1}", ResponseValues[Key], Value);
                        }
                        else
                        {
							ResponseValues.Add(Key, Value);
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
            if (ResponseValues.ContainsKey("Content-Length"))
            {
                bool ParseResult = int.TryParse(ResponseValues["Content-Length"], out ContentLength);

                if (ParseResult)
                {
                    byte [] Content = new byte[ContentLength];
                    Array.Copy(RawResponse, ContentBegin, Content, 0, ContentLength);

                    AttachedContent = new HttpContent(Content, HttpContent.ContentType.PlainText, Encoding.UTF8);

					if (ResponseValues.ContainsKey("Content-Type"))
					{
						string ContentType = ResponseValues["Content-Type"];
						if (ContentType.IndexOf("text/") != -1)
						{
							AttachedContent._ContentType = HttpContent.ContentType.PlainText;

							int CharsetPos = ContentType.IndexOf("charset=");
							if (CharsetPos != -1)
							{
								string Charset = ContentType.Substring(CharsetPos + "charset=".Length).Trim();
								AttachedContent._Encoding = (Charset.Equals("utf-8")) ? Encoding.UTF8 : Encoding.ASCII;
							}
						}
						else
						{
							AttachedContent._ContentType = HttpContent.ContentType.Binary;
						}
					}
				}
            }
        }

        public override string ToString()
		{
			if (AttachedContent != null)
			{
                if (AttachedContent._ContentType == HttpContent.ContentType.PlainText)
                {
                    return AttachedContent.StringRepresentation;
                }
                else
                {
                    return "[BINARY DATA]";
                }
			}
			
			return String.Empty;
		}
	}
}
