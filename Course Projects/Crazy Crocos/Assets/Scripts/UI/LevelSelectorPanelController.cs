using UnityEngine;
using UnityEngine.UI;

public class LevelSelectorPanelController : MonoBehaviour
{
	public GameObject[] LevelButtons;

	void Start ()
	{
		LevelManager.CreateInstance();

		string[] Levels = LevelManager.Instance.LevelNames;

		OnlineGameState GameState = OnlineGameState.Instance;
		GameSave Save = GameState.Team.Save;

		for (int i = 0; i < Levels.Length; i++)
		{
			LevelSelectorButton button = LevelButtons[i].GetComponent<LevelSelectorButton>();
			if (button != null)
			{
				button.LevelName = Levels[i];

				if (Save.LevelsInfo[i].Available)
				{
					button.Unlock();

					int minutes = Save.LevelsInfo[i].Minutes;
					int seconds = Save.LevelsInfo[i].Seconds;
					button.BestTimeText.GetComponent<Text>().text = string.Format("{0}:{1:00}", minutes, seconds);

					button.StarsImage.GetComponent<Image>().sprite =
						StarImagesStorage.GetStarImage(Save.LevelsInfo[i].Stars);
				}
			}
		}
	}
}
