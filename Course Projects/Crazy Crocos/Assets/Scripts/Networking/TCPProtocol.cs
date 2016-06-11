using Nexon;
using System.Collections.Generic;
using UnityEngine;

public sealed class TCPProtocol
{
	private static TCPProtocol _Instance;

	public static TCPProtocol Instance
	{
		get
		{
			if (_Instance == null)
			{
				_Instance = new TCPProtocol();
			}

			return _Instance;
		}
	}

	private delegate void Processor(string Data);
	private Dictionary<TCPCommand, Processor> Processors;

	private static int MessageIndex;

	private TCPProtocol()
	{
		RegisterCommandProcessors();
	}

	public void ProcessCommand(TCPCommand Command, string Data)
	{
		if (Processors.ContainsKey(Command))
		{
			Processors[Command](Data);
		}
	}

	private void RegisterCommandProcessors()
	{
		Processors = new Dictionary<TCPCommand, Processor>();

		Processors.Add(TCPCommand.PartnerConnectRequested, ProcessPartnerConnectRequest);
		Processors.Add(TCPCommand.OpenSwitchLevelScene, ProcessOpenSwitchLevelScene);
		Processors.Add(TCPCommand.AcceptConnectRequest, ProcessAcceptConnectRequest);
		Processors.Add(TCPCommand.StartLevel, ProcessStartLevel);
		Processors.Add(TCPCommand.PlayerControllerUpdate, ProcessPlayerControllerUpdate);
		Processors.Add(TCPCommand.LevelFailed, ProcessLevelFailed);
		Processors.Add(TCPCommand.ObjectReplication, ProcessObjectReplication);
	}

	private void ProcessPartnerConnectRequest(string Data)
	{
		Debug.LogError("<- PartnerConnectRequest");

		// Resolve attached player id
		int PartnerId;
		if (int.TryParse(Data, out PartnerId))
		{
			OnlineGameState GameState = OnlineGameState.Instance;
			GameState.ConnectPartner(PartnerId, true);
			GameState.Player.OrderInTeam = 1;

			// When partner registered, send confirmation message
			TCPMessage ConfirmationMessage = new TCPMessage(TCPCommand.AcceptConnectRequest);
			GameState.SendTCPMessageToPartner(ConfirmationMessage);

			Transition.Instance.SwitchToLevelSelectionScene();
		}
	}

	private void ProcessOpenSwitchLevelScene(string Data)
	{
		Debug.LogError("<- OpenSwitchLevelScene");

		Transition.Instance.SwitchToLevelSelectionScene();
	}

	private void ProcessAcceptConnectRequest(string Data)
	{
		Debug.LogError("<- AcceptConnectRequest");

		// When we know, that our partner confirmed connection request,
		// We can switch to level selection scene
		Transition.Instance.SwitchToLevelSelectionScene();
	}

	private void ProcessStartLevel(string Data)
	{
		Debug.LogError("<- StartLevel");

		Transition.Instance.GoToLevel(Data);
	}

	private void ProcessPlayerControllerUpdate(string Data)
	{
		Debug.LogError("<- PlayerControllerUpdate" + MessageIndex.ToString());
		MessageIndex++;

		// Parse received update package
		string[] ParsedUpdate = Data.Split('$');
		Vector3 position = new Vector3(float.Parse(ParsedUpdate[0]), float.Parse(ParsedUpdate[1]), 0.0f);
		Vector2 velocity = new Vector2(float.Parse(ParsedUpdate[2]), float.Parse(ParsedUpdate[3]));

		OnlineGameState GameState = OnlineGameState.Instance;
		GameState.UpdatePartnerPlayerState(position, velocity);
	}

	private void ProcessLevelFailed(string Data)
	{
		Debug.LogError("<- LevelFailed");

		GameNetworkContext.Instance.NetworkLevelFailed = true;
	}

	private void ProcessObjectReplication(string Data)
	{
		Debug.LogError("<- ObjectReplication");

		string[] ReplicationValues = Data.Split('$');
		int NetworkId = int.Parse(ReplicationValues[0]);
		GameNetworkContext.Instance.ProcessReplicationMessage(NetworkId, ReplicationValues[1], ReplicationValues[2]);
	}
}
