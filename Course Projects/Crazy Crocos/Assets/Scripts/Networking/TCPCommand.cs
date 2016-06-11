namespace Nexon
{
	public enum TCPCommand : int
	{
		PauseRequest = 1,
		ExitRequest = 2,
		ChatMessage = 3,
		PartnerConnectRequested = 4,
		ReadyToStartLevel = 5,
		OpenSwitchLevelScene = 6,
		AcceptConnectRequest = 7,
		StartLevel = 8,
		PlayerControllerUpdate = 9,
		LevelFailed = 10,
		ObjectReplication = 11
	}
}
