using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Metrics {

	public class PreConditionLoop : Operator {

		public String LoopCondition;
		public Operator LoopedOperator;

		public PreConditionLoop()
			: base() {
			this.Type = OperatorType.PreConditionLoop;
		}

		public PreConditionLoop(String LoopCondition, Operator LoopedOperator)
			: base() {
			this.Type = OperatorType.PreConditionLoop;
			this.LoopCondition = LoopCondition;
			this.LoopedOperator = LoopedOperator;
		}

		public override string ToString() {
			return String.Format(
				"<PreConditionLoop {2} Condition=\"{0}\">\n{1}\n</PreConditionLoop>",
				LoopCondition, LoopedOperator, GetCommonOperatorInfo()
			);
		}

		public override void Enumerate(ref Int32 Index) {
			base.Enumerate(ref Index);

			if (LoopedOperator != null)
				LoopedOperator.Enumerate(ref Index);
		}

		public override Operator BuildLinks(Operator PreviousOperator, ref Int32 LinksCount) {
			base.BuildLinks(PreviousOperator, ref LinksCount);
			PreviousOperator = this;

			if (LoopedOperator != null) {
				Operator LastOperator = LoopedOperator.BuildLinks(PreviousOperator, ref LinksCount);
				LastOperator.Links.Add(this.OperatorIndex);
			}

			return this;
		}

	}

}
