using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Metrics {

	public struct GraphInfo {
		public Int32 NodesCount;
		public Int32 LinksCount;
		public Int32 MetricValue;

		public String MetricText;
	}

	public class CFunction {

		const Int32 MetricHardLinkKoefficient = 2;

		public String Type;
		public String Name;

		public ComplexOperator RootOperator;

		public CFunction() {
			this.Type = this.Name = String.Empty;
			this.RootOperator = null;
		}

		public CFunction(String Type, String Name, String FunctionCode) {
			this.Type = Type;
			this.Name = Name;
			this.RootOperator = new ComplexOperator(FunctionCode, 0);
		}

		public static OperatorType GetNextOperatorType(List<String> IdentifiersList, Int32 Index) {
			return GetOperatorType(IdentifiersList [Index]);
		}

		public static OperatorType GetOperatorType(String OperatorText) {
			if (OperatorText == "if")
				return OperatorType.Conditional;
			else if (OperatorText == "for" || OperatorText == "while")
				return OperatorType.PreConditionLoop;
			else if (OperatorText == "do")
				return OperatorType.PostConditionLoop;
			else if (OperatorText == "switch")
				return OperatorType.Switch;
			else if (OperatorText [0] == NexonStringUtils.CurvedBrackets.OpenerBracket)
				return OperatorType.Complex;
			else
				return OperatorType.Single;
		}

		public static ConditionalOperator GetNextConditionalOperator(Stack<String> IdentifiersStack) {
			IdentifiersStack.Pop();
			ConditionalOperator Result = new ConditionalOperator();

			Result.Condition = IdentifiersStack.Pop();
			Result.TrueBranch = GetNextOperator(IdentifiersStack);

			if (IdentifiersStack.Count > 0 && IdentifiersStack.Peek().Equals("else")) {
				IdentifiersStack.Pop();
				Result.FalseBranch = GetNextOperator(IdentifiersStack);
			}

			return Result;
		}

		public static ComplexOperator GetNextComplexOperator(Stack<String> IdentifiersStack) {
			String ComplexOperatorBody = IdentifiersStack.Pop();
			ComplexOperatorBody = ComplexOperatorBody.Substring(1, ComplexOperatorBody.Length - 2).Trim();
			
			return new ComplexOperator(ComplexOperatorBody, 0);
		}

		public static PreConditionLoop GetNextPreConditionLoop(Stack<String> IdentifiersStack) {
			IdentifiersStack.Pop();
			String LoopCondition = IdentifiersStack.Pop();
			Operator LoopedOperator = GetNextOperator(IdentifiersStack);

			return new PreConditionLoop(LoopCondition, LoopedOperator);
		}

		public static PostConditionLoop GetNextPostConditionLoop(Stack<String> IdentifiersStack) {
			IdentifiersStack.Pop();	// Remove 'do'
			Operator LoopedOperator = GetNextOperator(IdentifiersStack);
			IdentifiersStack.Pop();	// Remove 'while'
			String LoopCondition = IdentifiersStack.Pop();

			return new PostConditionLoop(LoopCondition, LoopedOperator);
		}

		public static SwitchOperator GetNextSwitch(Stack<String> IdentifiersStack) {
			IdentifiersStack.Pop();	// Remove 'switch'

			String Variable = IdentifiersStack.Pop();
			SwitchOperator Switch = new SwitchOperator(Variable);
			IdentifiersStack.Pop(); // Skip operator

			return Switch;
		}

		public static Operator GetNextOperator(Stack<String> IdentifiersStack) {
			String StructureIdentifier = IdentifiersStack.Peek();
			OperatorType Type = CFunction.GetOperatorType(StructureIdentifier);

			switch (Type) {
				case OperatorType.Conditional:
					return GetNextConditionalOperator(IdentifiersStack);
				case OperatorType.Complex:
					return GetNextComplexOperator(IdentifiersStack);
				case OperatorType.PreConditionLoop:
					return GetNextPreConditionLoop(IdentifiersStack);
				case OperatorType.PostConditionLoop:
					return GetNextPostConditionLoop(IdentifiersStack);
				case OperatorType.Switch:
				case OperatorType.Single:
				default:
					return new Operator(IdentifiersStack.Pop());
			}
		}

		public override String ToString() {
			return String.Format(
				"<Function Type=\"{0}\" Name=\"{1}\">\n{2}\n</Function>",
				Type, Name, RootOperator.ToString()
			);
		}

		public GraphInfo GetGraphInfo() {
			GraphInfo Result;
			Result.NodesCount = EnumerateFunctionOperators();
			Result.LinksCount = BuildOperatorLinks();
			Result.MetricValue = Result.LinksCount - Result.NodesCount + MetricHardLinkKoefficient;
			Result.MetricText = String.Format(
				"{3} {4}:\nКол-во дуг: {0}; Кол-во узлов: {1};\nЗначение метрики: {2}\n",
				Result.LinksCount, Result.NodesCount, Result.MetricValue, Type, Name
			);
			return Result;
		}

		public Int32 EnumerateFunctionOperators() {
			Int32 CurrentIndex = 0;
			RootOperator.Enumerate(ref CurrentIndex);

			return CurrentIndex;
		}

		public Int32 BuildOperatorLinks() {
			Int32 LinksCount = 0;
			RootOperator.BuildLinks(null, ref LinksCount);

			return LinksCount;
		}

	}

}
