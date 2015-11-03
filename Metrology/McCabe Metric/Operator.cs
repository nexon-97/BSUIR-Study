using System;
using System.Collections.Generic;
using System.Text;

namespace Metrics {

	public enum OperatorType {
		Single,
		Conditional,
		Complex,
		PreConditionLoop,
		PostConditionLoop,
		Switch
	}

	public class Operator {	

		public String Code;
		public OperatorType Type;
		public Int32 OperatorIndex;

		public List<Int32> Links = new List<Int32>();

		public Operator() {
			this.Code = String.Empty;
			this.Type = OperatorType.Single;
		}

		public Operator(String Code) {
			this.Code = Code;
			this.Type = OperatorType.Single;
		}

		public virtual void BuildFromIdentifiersList(List<String> IdentifiersList, ref Int32 Index) {
			Index++;
		}

		protected void ReplaceRoundBrackets(List<String> IdentifiersList) {
			for (Int32 i = 1; i < IdentifiersList.Count; i++) {
				if (
					(IdentifiersList [i] [0] == NexonStringUtils.RoundBrackets.OpenerBracket) &&
					(!NexonStringUtils.IsCLanguageKeyword(IdentifiersList [i - 1]))
				) {
					IdentifiersList.RemoveAt(i--);
				}
			}
		}

		protected List<String> BuildIdentifiersList() {
			List<String> IdentifiersList = new List<String>();

			StringBuilder IdentifierBuilder = new StringBuilder();

			for (Int32 Index = 0; Index < Code.Length; Index++) {
				if (NexonStringUtils.IsBracketOpener(Code [Index])) {
					FlushStringBuilderToList(IdentifierBuilder, IdentifiersList);

					Int32 CloserBracket = NexonStringUtils.GetCloserBracketPosition(
						Code, NexonStringUtils.GetBracketTypeByOpener(Code [Index]), Index
					);
					IdentifiersList.Add(Code.Substring(Index, CloserBracket - Index + 1));

					Index = CloserBracket;
				} else if (NexonStringUtils.IsSemicolon(Code [Index])) {
					FlushStringBuilderToList(IdentifierBuilder, IdentifiersList);
				} else {
					IdentifierBuilder.Append(Code [Index]);
				}
			}

			ReplaceRoundBrackets(IdentifiersList);
			return IdentifiersList;
		}

		protected Stack<String> BuildIdentifiersStack() {
			List<String> IdentifiersList = BuildIdentifiersList();
			IdentifiersList.Reverse();

			Stack<String> IdentifiersStack = new Stack<String>();
			foreach (String Element in IdentifiersList) {
				IdentifiersStack.Push(Element);
			}

			return IdentifiersStack;
		}

		protected void FlushStringBuilderToList(StringBuilder Builder, List<String> StringList) {
			String StringToAdd = Builder.ToString().Trim();
			Builder.Clear();

			if (StringToAdd.Length > 0) {
				NexonStringUtils.KeywordSearchInfo KeywordSearch = NexonStringUtils.StatementsBeginsFromKeyword(StringToAdd);
				if (KeywordSearch.Found) {
					StringList.Add(StringToAdd.Substring(0, KeywordSearch.Length));
					StringToAdd = StringToAdd.Substring(KeywordSearch.Length).Trim();

					if (StringToAdd.Length > 0)
						StringList.Add(StringToAdd);
				} else
					StringList.Add(StringToAdd);
			}
		}

		public override string ToString() {
			return String.Format(
				"<Operator id=\"{0}\" links=\"{1}\"/>",
				OperatorIndex, PrintInt32List(Links)
			);
		}

		public virtual void Enumerate(ref Int32 Index) {
			OperatorIndex = Index++;
		}

		public static String PrintInt32List(List<Int32> ListToPrint) {
			StringBuilder Builder = new StringBuilder();
			foreach (Int32 Element in ListToPrint) {
				Builder.AppendFormat("{0};", Element.ToString());
			}
			return Builder.ToString();
		}

		public String GetCommonOperatorInfo() {
			return String.Format("id=\"{0}\" links=\"{1}\"", OperatorIndex, PrintInt32List(Links));
		}

		public virtual Operator BuildLinks(Operator PreviousOperator, ref Int32 LinksCount) {
			if (PreviousOperator != null) {
				PreviousOperator.Links.Add(OperatorIndex);
				LinksCount++;
			}

			return this;
		}

	}

}
