using System;
using System.Collections.Generic;

namespace Metrics {

	public class ConditionalOperator : Operator {

		public String Condition;
		public Operator TrueBranch;
		public Operator FalseBranch;

		public ConditionalOperator() : base() {
			this.Type = OperatorType.Conditional;
		}

		public override void BuildFromIdentifiersList(List<String> IdentifiersList, ref Int32 Index) {
			Condition = IdentifiersList [Index + 1];
		}

		public override string ToString() {
			String TrueBranchString = (TrueBranch != null)
				? String.Format("<TrueBranch>\n{0}\n</TrueBranch>", TrueBranch.ToString())
				: String.Empty;
			String FalseBranchString = (FalseBranch != null)
				? String.Format("\n<FalseBranch>\n{0}\n</FalseBranch>", FalseBranch.ToString())
				: String.Empty;

			return String.Format(
				"<ConditionalOperator {3} Condition=\"{0}\">\n{1}{2}\n</ConditionalOperator>",
				Condition, TrueBranchString, FalseBranchString, GetCommonOperatorInfo()
			);
		}

		public override void Enumerate(ref Int32 Index) {
			base.Enumerate(ref Index);

			if (TrueBranch != null)
				TrueBranch.Enumerate(ref Index);
			if (FalseBranch != null)
				FalseBranch.Enumerate(ref Index);
		}

		public override Operator BuildLinks(Operator PreviousOperator, ref Int32 LinksCount) {
			base.BuildLinks(PreviousOperator, ref LinksCount);
			PreviousOperator = this;

			if (TrueBranch != null) {
				Operator LastOperator = TrueBranch.BuildLinks(PreviousOperator, ref LinksCount);
				LastOperator.Links.Add(this.OperatorIndex);

				PreviousOperator = this;
			}
			if (FalseBranch != null) {
				Operator LastOperator = FalseBranch.BuildLinks(PreviousOperator, ref LinksCount);
				LastOperator.Links.Add(this.OperatorIndex);

				PreviousOperator = this;
			}

			return this;
		}

	}

}
