using UnityEngine;
using System.Collections.Generic;

public class GameNetworkContext : MonoBehaviour
{
	public static GameNetworkContext Instance;

	public bool NetworkLevelFailed;

	public Dictionary<int, ReplicatedObject> ReplicatedObjects = new Dictionary<int, ReplicatedObject>();

	void Start ()
	{
		Instance = this;
	}

	private void OnApplicationQuit()
	{
		Debug.Log("Application exited");

		// Drop all current player sessions
		OnlineGameState GameState = OnlineGameState.Instance;
		GameState.Player.EndSessions();
	}

	private void Update()
	{
		if (NetworkLevelFailed)
		{
			LevelController.GetInstance().SetLevelFailed(true);
			NetworkLevelFailed = false;
		}
	}

	public void AddReplicatedObject(ReplicatedObject Object)
	{
		ReplicatedObjects.Add(Object.NetworkId, Object);
	}

	public void ProcessReplicationMessage(int NetworkId, string Property, string Value)
	{
		if (ReplicatedObjects.ContainsKey(NetworkId))
		{
			ReplicatedObjects[NetworkId].ReplicationNotify(Property, Value);
		}
	}
}
