using System;
using System.Text;

namespace Metrics {

	public static class NexonStringUtils {

		// Regex Patterns
		public static String IdentifierRegex = @"\b([a-zA-Z_][a-zA-Z0-9_]*)\b";
		public static String PointerRegex = @"\s*\**\s*";
		public static String FunctionParamsRegex = @"\(.*\)";
		public static String
			FunctionSignatureRegex = IdentifierRegex + PointerRegex + IdentifierRegex + FunctionParamsRegex + @"\s*({)";

		// Bracket Pair Struct
		public struct BracketPair {
			public Char OpenerBracket;
			public Char CloserBracket;

			public BracketPair(Char OpenerBracket, Char CloserBracket) {
				this.OpenerBracket = OpenerBracket;
				this.CloserBracket = CloserBracket;
			}
		}

		public static BracketPair CurvedBrackets = new BracketPair('{', '}');
		public static BracketPair RoundBrackets = new BracketPair('(', ')');

		// Other structs
		public struct SignificantCharInfo {
			public Char SignificantChar;
			public Int32 Index;

			public SignificantCharInfo(Char SignificantChar, Int32 Index) {
				this.SignificantChar = SignificantChar;
				this.Index = Index;
			}
		}

		public struct KeywordSearchInfo {
			public Boolean Found;
			public Int32 Length;

			public KeywordSearchInfo(Boolean Found, Int32 Length) {
				this.Found = Found;
				this.Length = Length;
			}
		}

		public static Char SpaceChar = ' ';
		public static Char Semicolon = ';';

		public static String [] CLanguageKeywords = {
			"if", "else", "while", "do", "for", "break", "continue", "switch"
		};


		// Static methods
		public static Boolean CompareStringOffsetToExample(
			String ComparedString, Int32 Offset, String Example
		) {
			return (
				(ComparedString.Length >= Offset + Example.Length) &&
				(ComparedString.Substring(Offset, Example.Length).Equals(Example))
			);
		}

		public static String HardTrim(String Original) {
			Int32 Head, Tail;

			for (Head = 0; Head < Original.Length; Head++)
				if (Original[Head] > '\x20')
					break;
			for (Tail = Original.Length - 1; Tail >= 0; Tail--)
				if (Original [Tail] > '\x20')
					break;

			return Original.Substring(Head, Tail - Head + 1);
		}

		public static Int32 NextIndex(Int32 Current) {
			return Current + 1;
		}

		public static Int32 GetCloserBracketPosition(String Source, BracketPair Brackets, Int32 OpenerBracketPos) {
			const Int32 UndefinedPosition = 0;
			Int32 CloserBracketPos = UndefinedPosition;
			Int32 BracketState = 1;

			for (Int32 i = NextIndex(OpenerBracketPos); i < Source.Length; i++) {
				if (Source [i] == Brackets.CloserBracket)
					BracketState--;
				else if (Source [i] == Brackets.OpenerBracket)
					BracketState++;

				if (BracketState == 0) {
					CloserBracketPos = i;
					break;
				}
			}

			return CloserBracketPos;
		}

		public static SignificantCharInfo GetFirstSignificantChar(String Source, Int32 StartIndex) {
			while (StartIndex < Source.Length) {
				if (NexonStringUtils.IsSignificant(Source [StartIndex]))
					return new SignificantCharInfo(Source [StartIndex], StartIndex);
				StartIndex++;
			}

			return new SignificantCharInfo(NexonStringUtils.SpaceChar, StartIndex);
		}

		public static Boolean IsSignificant(Char TestChar) {
			return (TestChar > SpaceChar);
		}

		public static Boolean IsBracketOpener(Char TestChar) {
			return (TestChar == CurvedBrackets.OpenerBracket || TestChar == RoundBrackets.OpenerBracket);
		}

		public static Boolean IsSemicolon(Char TestChar) {
			return (TestChar == Semicolon);
		}

		public static BracketPair GetBracketTypeByOpener(Char Opener) {
			return (Opener == RoundBrackets.OpenerBracket) ? RoundBrackets : CurvedBrackets;
		}

		public static Boolean IsCLanguageKeyword(String TestString) {
			foreach (String Keyword in CLanguageKeywords)
				if (Keyword.Equals(TestString))
					return true;
			return false;
		}

		public static KeywordSearchInfo StatementsBeginsFromKeyword(String Statement) {
			foreach (String Keyword in CLanguageKeywords)
				if (CompareStringOffsetToExample(Statement, 0, Keyword))
					return new KeywordSearchInfo(true, Keyword.Length);
			return new KeywordSearchInfo(false, 0);
		}

	}

}
