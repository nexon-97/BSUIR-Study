using UnityEngine;
using UnityEngine.UI;

public class PartnerButtonController : MonoBehaviour
{
	private Button ButtonComponent;
	public int Id;

	private void Start ()
	{
		ButtonComponent = gameObject.GetComponent<Button>();

		ButtonComponent.onClick.AddListener( () => { OnClick(); }) ;
	}
	
	public void OnClick()
	{
		OnlineGameState GameState = OnlineGameState.Instance;
		GameState.ConnectPartner(Id, false);
		GameState.Player.OrderInTeam = 0;
	}
}
