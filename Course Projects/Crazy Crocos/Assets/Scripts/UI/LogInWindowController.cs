using UnityEngine;
using UnityEngine.UI;
using System.Net;
using System.Collections.Generic;

public class LogInWindowController : MonoBehaviour
{
	public InputField LoginInput;
	public InputField PasswordInput;

	public void LogIn()
	{
		bool LoggedIn = NetworkController.Instance.ActivePlayer.LogIn(LoginInput.text, PasswordInput.text);
		LoginInput.text = PasswordInput.text = string.Empty;

		if (LoggedIn)
		{
			// Start player sessions
			NetworkController.Instance.StartActivePlayerSessions();

			MainMenuController.Instance.OpenMainLayout();	
		}	
	}
}
