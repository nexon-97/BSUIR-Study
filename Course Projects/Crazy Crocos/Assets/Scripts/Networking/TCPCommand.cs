namespace Nexon
{
	public enum TCPCommand
	{
		PartnerLoggedIn = 1,
		PartnerLoggedOut = 2,
		Timeout = 3,
		PauseRequest = 4,
		ExitRequest = 5,
		ChatMessage = 6,
		PartnerConnectRequested = 7,
		PartnerDisconnected = 8,
		ReadyToStartLevel = 9,
	}
}
