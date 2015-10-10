using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Metrics {

	public static class NexonStringUtils {

		public static Boolean CompareStringOffsetToExample(
			String ComparedString, Int32 Offset, String Example
		) {
			return (
				(ComparedString.Length >= Offset + Example.Length) &&
				(ComparedString.Substring(Offset, Example.Length).Equals(Example))
			);
		}

	}

}
