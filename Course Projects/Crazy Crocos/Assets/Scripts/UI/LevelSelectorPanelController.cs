using UnityEngine;
using UnityEngine.UI;

public class LevelSelectorPanelController : MonoBehaviour
{
	public GameObject[] LevelButtons;

	void Start ()
	{
		LevelManager.CreateInstance();
		PlayerManager.CreateInstance();

		string[] Levels = LevelManager.Instance.LevelNames;
		PlayerInfo ActivePlayerInfo = PlayerManager.Instance.ActivePlayer;

		for (int i = 0; i < Levels.Length; i++)
		{
			LevelSelectorButton button = LevelButtons[i].GetComponent<LevelSelectorButton>();
			if (button != null)
			{
				button.LevelName = Levels[i];

				if (ActivePlayerInfo.LevelsInfo[i].Available)
				{
					button.Unlock();

					int minutes = ActivePlayerInfo.LevelsInfo[i].Minutes;
					int seconds = ActivePlayerInfo.LevelsInfo[i].Seconds;
					button.BestTimeText.GetComponent<Text>().text = string.Format("{0}:{1:00}", minutes, seconds);

					button.StarsImage.GetComponent<Image>().sprite =
						StarImagesStorage.GetStarImage(ActivePlayerInfo.LevelsInfo[i].Stars);
				}
			}
		}
	}
}
