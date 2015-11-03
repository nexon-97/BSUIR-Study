using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Xml.Serialization;
using System.Linq;
using System.Windows.Controls;

namespace Metrics {

	public class CCode {

		public String Code;
		List<CFunction> CodeFunctions;

		public CCode() { }

		public CCode(String Source) {
			Code = Source;
		}

		public OrientedGraph BuildControlFlowGraph() {
			CodeFunctions = GetDocumentFunctions();

			OrientedGraph ControlFlowGraph = new OrientedGraph();
			return ControlFlowGraph;
		}

		public List<CFunction> GetDocumentFunctions() {
			List<CFunction> FunctionList = new List<CFunction>();

			Regex Expression = new Regex(NexonStringUtils.FunctionSignatureRegex);

			Match FunctionSignatureMatch;
			Int32 MatchStart = 0;
			do {
				FunctionSignatureMatch = Expression.Match(Code, MatchStart);

				if (FunctionSignatureMatch.Success) {
					GroupCollection MatchGroups = FunctionSignatureMatch.Groups;

					Int32 CodeStartPos = NexonStringUtils.NextIndex(FunctionSignatureMatch.Groups [3].Index);
					Int32 CloserBracketPos = NexonStringUtils.GetCloserBracketPosition(Code, NexonStringUtils.CurvedBrackets, CodeStartPos);

					FunctionList.Add(
						new CFunction(
							FunctionSignatureMatch.Groups [1].Value, FunctionSignatureMatch.Groups [2].Value,
							Code.Substring(CodeStartPos, CloserBracketPos - CodeStartPos).Trim()
						)
					);
					MatchStart = NexonStringUtils.NextIndex(CloserBracketPos);
				}
			} while (FunctionSignatureMatch.Success);

			return FunctionList;
		}

		public void PrintDocument() {
			Type [] ExtraTypes = {
				typeof(Operator), typeof(ConditionalOperator), typeof(ComplexOperator),
				typeof(CFunction), typeof(PreConditionLoop),
				typeof(PostConditionLoop)
			};
			var XmlSerializer = new XmlSerializer(typeof(List<CFunction>), ExtraTypes);
			using (var XmlFileStream = new FileStream("xml.xml", FileMode.Create)) {
				XmlSerializer.Serialize(XmlFileStream, CodeFunctions);
			}

			StringBuilder FunctionsText = new StringBuilder();
			foreach (CFunction Function in CodeFunctions) {
				FunctionsText.Append(Function.ToString());
			}
			File.WriteAllText("code_tree.xml", FunctionsText.ToString());
		}

		public void CountMetrics(TextBox OutputTextBlock) {
			Int32 Sum = 0;
			Int32 FunctionCount = 0;

			foreach (CFunction Function in CodeFunctions) {
				GraphInfo Info = Function.GetGraphInfo();
				
				OutputTextBlock.Text += Info.MetricText;
				Sum += Info.MetricValue;
				FunctionCount++;
			}

			Int32 FinalMetric = Sum - FunctionCount + 1;
			OutputTextBlock.Text += String.Format(
				"\nИтоговое значение метрики: {0}",
				FinalMetric
			);
		}
			
	}

}
