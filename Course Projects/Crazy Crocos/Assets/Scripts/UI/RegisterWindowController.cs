using UnityEngine;
using UnityEngine.UI;
using System.Net;
using System.Collections.Generic;

public class RegisterWindowController : MonoBehaviour
{
	public InputField NameInput;
	public InputField PasswordInput;
	
	public void Register()
	{
		WebRequest RegisterRequest = NetworkController.Instance.GeneratePostRequest(
			"register",
			new Dictionary<string, string>()
			{
				{ "login", NameInput.text },
				{ "password", PasswordInput.text }
			}
		);
		NameInput.text = PasswordInput.text = string.Empty;

		string Response = NetworkController.Instance.GetResponseString(RegisterRequest).Trim();
		if (Response.IndexOf("OK") == 0)
		{
			const string RegisterSuccessMessage = "Thanks for registering!\nNow you can log in with your credentials";
			MainMenuController.Instance.ShowMessageBox(RegisterSuccessMessage);
		}
		else
		{
			const string FailMessage = "Failed to register";
			MainMenuController.Instance.ShowMessageBox(Response);
		}
	}
}
