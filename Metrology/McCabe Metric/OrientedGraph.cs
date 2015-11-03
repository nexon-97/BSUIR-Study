using System;
using System.Collections.Generic;

namespace Metrics {

	public enum NodeType {
		Code, Condition, WhileLoop, DoWhileLoop, Switch
	}

	public struct GraphNode {
		public static Int32 CurrentIndex = 0;

		public Int32 Index;
		public List<Int32> Links;

		public GraphNode(Int32 Index, List<Int32> Links) {
			this.Index = Index;
			this.Links = Links;
		}
	}

	public class OrientedGraph {

		public List<GraphNode> Nodes = new List<GraphNode>();

		public Int32 VertexCount {
			get { return Nodes.Count; }
		}

		public Int32 ArcsCount {
			get {
				Int32 Result = 0;

				foreach (GraphNode Node in Nodes)
					Result += Node.Links.Count;

				return Result;
			}
		}


		public OrientedGraph() { }

		public void AddNode(Int32 Index, List<Int32> Links) {
			Nodes.Add(new GraphNode(Index, Links));
		}

		public void AddNode() {
			Nodes.Add(new GraphNode(GraphNode.CurrentIndex++, null));
		}

		public void AddLink(Int32 NodeFrom, Int32 NodeTo) {
			Nodes.Add(new GraphNode(GraphNode.CurrentIndex++, null));
		}

		public void BuildFromRootOperator(ComplexOperator RootOperator) {
			const Int32 EmptyNodeIndex = -1;
			Int32 NodeFrom = EmptyNodeIndex;

			foreach (Operator Element in RootOperator.Operators) {
				if (NodeFrom != EmptyNodeIndex) {
					AddNode();
				} else {

				}
			}
		}

	}

}
