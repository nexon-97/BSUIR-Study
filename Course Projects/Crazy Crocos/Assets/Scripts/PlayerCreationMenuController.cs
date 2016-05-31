using UnityEngine;
using UnityEngine.UI;

public class PlayerCreationMenuController : MonoBehaviour
{
	public static PlayerCreationMenuController Instance;

	public PlayerInfo Info;
	public InputField NameInput;
	public PlayerPreviewPanel LeftTeamPanel;
	public PlayerPreviewPanel RightTeamPanel;

	void Start()
	{
		Instance = this;
		Info = new PlayerInfo();
	}

	void Update()
	{
		Info.Name = NameInput.text;
		Info.LeftTeam = LeftTeamPanel.CurrentState;
		Info.RightTeam = RightTeamPanel.CurrentState;
	}
}
