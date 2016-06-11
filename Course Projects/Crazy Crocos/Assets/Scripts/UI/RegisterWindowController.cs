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
		HttpWebRequest RegisterRequest = WebServices.GeneratePostRequest(
			"register",
			new Dictionary<string, string>()
			{
				{ "login", NameInput.text },
				{ "password", PasswordInput.text }
			}
		);
		NameInput.text = PasswordInput.text = string.Empty;

		string Response = WebServices.GetResponseString(RegisterRequest).Trim();
		if (Response.IndexOf("OK") == 0)
		{
			const string RegisterSuccessMessage = "Thanks for registering!\nNow you can log in with your credentials";
			MainMenuController.Instance.ShowMessageBox(RegisterSuccessMessage);
		}
		else
		{
			MainMenuController.Instance.ShowMessageBox(Response.Substring(Response.IndexOf(":") + 1).Trim());
		}
	}
}
