using System;
using System.Collections.Generic;
using System.Text;

namespace Metrics {

	public class ComplexOperator : Operator {

		public List<Operator> Operators = new List<Operator>();

		public ComplexOperator() : base() {
			this.Type = OperatorType.Complex;
		}

		public ComplexOperator(String Code, Int32 PositionInParent)
			: base(Code) {
			BuildOperatorsList();

			this.Code = String.Empty;
			this.Type = OperatorType.Complex;
		}

		public void BuildFromIdentifiersStack(Stack<String> IdentifiersStack) {
			while (IdentifiersStack.Count > 0) {
				Operators.Add(CFunction.GetNextOperator(IdentifiersStack));
			}
		}

		protected void BuildOperatorsList() {
			Stack<String> IdentifiersStack = BuildIdentifiersStack();

			BuildFromIdentifiersStack(IdentifiersStack);
		}

		public override string ToString() {
			StringBuilder ComplexOperatorBuilder = new StringBuilder();
			ComplexOperatorBuilder.Append("<ComplexOperator>\n");

			for (Int32 Index = 0; Index < Operators.Count; Index++) {
				ComplexOperatorBuilder.Append(Operators[Index]);
				ComplexOperatorBuilder.Append("\n");
			}

			ComplexOperatorBuilder.Append("</ComplexOperator>");
			return ComplexOperatorBuilder.ToString();
		}

		public override void Enumerate(ref Int32 Index) {
			OperatorIndex = Index;

			foreach (Operator Element in Operators) {
				Element.Enumerate(ref Index);
			}
		}

		public override Operator BuildLinks(Operator PreviousOperator, ref Int32 LinksCount) {
			base.BuildLinks(PreviousOperator, ref LinksCount);
			PreviousOperator = this;

			for (Int32 i = 0; i < Operators.Count; i++) {
				Operators [i].BuildLinks(PreviousOperator, ref LinksCount);

				PreviousOperator = Operators [i];
			}

			if (Operators.Count > 0)
				return Operators [Operators.Count - 1];
			else
				return null;
		}

	}

}
