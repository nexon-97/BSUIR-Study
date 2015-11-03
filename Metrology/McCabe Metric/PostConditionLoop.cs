using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Metrics {

	public class PostConditionLoop : PreConditionLoop {

		public PostConditionLoop()
			: base() {
			this.Type = OperatorType.PreConditionLoop;
		}

		public PostConditionLoop(String LoopCondition, Operator LoopedOperator)
			: base() {
			this.Type = OperatorType.PreConditionLoop;
			this.LoopCondition = LoopCondition;
			this.LoopedOperator = LoopedOperator;
		}

		public override string ToString() {
			return String.Format(
				"<PostConditionLoop {2} Condition=\"{0}\">\n{1}\n</PostConditionLoop>",
				LoopCondition, LoopedOperator, GetCommonOperatorInfo()
			);
		}

	}

}
