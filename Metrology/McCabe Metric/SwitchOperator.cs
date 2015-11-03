using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Metrics {

	public class SwitchOperator : Operator {

		public String Variable;

		public SwitchOperator()
			: base() {
			this.Type = OperatorType.Switch;
		}

		public SwitchOperator(String Variable)
			: base() {
			this.Type = OperatorType.Switch;
			this.Variable = Variable;
		}

		public override string ToString() {
			return String.Format(
				"<Switch Variable=\"{0}\">\n{1}\n</Switch>",
				Variable
			);
		}

		public override void Enumerate(ref Int32 Index) {
			base.Enumerate(ref Index);
		}

	}

}
