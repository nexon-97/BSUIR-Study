using UnityEngine;

public class PlayerPreviewPanel : MonoBehaviour
{
	public int CurrentState;
	public GameObject[] States;

	private void Start()
	{
		UpdateVisualState();
	}

	public void Next()
	{
		if (CurrentState >= 3)
		{
			CurrentState = 0;
		}
		else
		{
			CurrentState++;
		}

		UpdateVisualState();
	}

	public void UpdateVisualState()
	{
		for (int i = 0; i < States.Length; i++)
		{
			States[i].SetActive(i == CurrentState);
		}
	}
}
