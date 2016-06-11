using UnityEngine;
using UnityEngine.UI;

public class LogInWindowController : MonoBehaviour
{
	public InputField LoginInput;
	public InputField PasswordInput;

	public void LogIn()
	{
		OnlineGameState GameState = OnlineGameState.Instance;

		bool LoggedIn = GameState.Player.LogIn(LoginInput.text, PasswordInput.text);
		LoginInput.text = PasswordInput.text = string.Empty;

		if (LoggedIn)
		{
			// Start player sessions
			GameState.Player.StartSessions();

			MainMenuController.Instance.OpenMainLayout();	
		}	
	}
}
