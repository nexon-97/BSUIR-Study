using System;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections.Generic;

namespace ChepinMetric
{

	public abstract class Preprocessor
	{

		public const Char StringLiteralBorder = '"';
		public const Char CharLiteralBorder = '\'';

		public const Int32 IndexNotFound = -1;

		public enum LiteralType { String, Character }

		public static void RemoveStrings(List<String> SourceLines)
		{
			for (Int32 Line = 0; Line < SourceLines.Count; Line++)
			{
				StringBuilder LineBuilder = new StringBuilder();
				String SourceLine = SourceLines [Line];

				for (Int32 CharIndex = 0; CharIndex < SourceLine.Length; CharIndex++)
				{
					switch (SourceLine[CharIndex])
					{
						case StringLiteralBorder:
							CharIndex = GetLiteralCloserPosition(SourceLine, CharIndex + 1, LiteralType.String);
							break;
						case CharLiteralBorder:
							CharIndex = GetLiteralCloserPosition(SourceLine, CharIndex + 1, LiteralType.Character);
							break;
						default:
							LineBuilder.Append(SourceLine [CharIndex]);
							break;
					}
				}

				SourceLines [Line] = LineBuilder.ToString();
				if (SourceLines [Line].Equals(String.Empty))
				{
					SourceLines.RemoveAt(Line);
					Line--;
				}
			}
		}

		public static void PreprocessCode(List<String> SourceLines)
		{
			RemoveComments(SourceLines);
			RemoveStrings(SourceLines);
		}

		private static void RemoveComments(List<String> SourceLines)
		{
			for (Int32 Line = 0; Line < SourceLines.Count; Line++)
			{
				String SourceLine = SourceLines [Line].Trim();

				// Remove empty and commented line
				if ((SourceLine.Length == 0) || (SourceLine [0] == '*' || SourceLine [0] == '/'))
				{
					SourceLines.RemoveAt(Line);
					Line--;
				}
			}
		}

		private static Int32 GetLiteralCloserPosition(String Code, Int32 SearchOffset, LiteralType Type)
		{
			Regex Expression = (Type == LiteralType.String)
				? (new Regex("[^\\\\]?\""))
				: (new Regex("[^\\\\]?'"));

			Match CloserMatch = Expression.Match(Code, SearchOffset);
			return (CloserMatch.Success) ? (CloserMatch.Index + CloserMatch.Length - 1) : (Code.Length - 1);
		}

	}

}