using UnityEngine;
using Nexon;

public class LevelSelectorButton : MonoBehaviour
{
	public string LevelName;
	public GameObject Locker;
	public GameObject BestTimeText;
	public GameObject StarsImage;

	public void LoadLevel()
	{
		OnlineGameState GameState = OnlineGameState.Instance;
		GameState.SendTCPMessageToPartner(new TCPMessage(TCPCommand.StartLevel, LevelName));

		Transition.Instance.GoToLevel(LevelName);
	}

	public void Unlock()
	{
		if (Locker != null)
		{
			Locker.SetActive(false);
		}
	}
}
