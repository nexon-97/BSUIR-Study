using UnityEngine;
using Nexon;
using System.Collections.Generic;

public class ReplicatedObject : MonoBehaviour
{
	public int NetworkId;

	protected List<string> ReplicatedProperties;
	protected bool IsReplicated;

	protected void RegisterInNetworkContext()
	{
		IsReplicated = (OnlineGameState.Instance.Player.OrderInTeam == 1);
		GameNetworkContext.Instance.AddReplicatedObject(this);
	}

	public virtual void ReplicationNotify(string Property, string Value)
	{

	}

	public void ReplicateProperty(string Property, string Value)
	{
		if (IsReplicated)
		{
			string Data = string.Format("{0}${1}${2}", NetworkId.ToString(), Property, Value);
			TCPMessage ReplicationMessage = new TCPMessage(TCPCommand.ObjectReplication, Data);

			OnlineGameState.Instance.SendTCPMessageToPartner(ReplicationMessage);
		}
	}
}
