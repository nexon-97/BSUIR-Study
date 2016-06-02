using UnityEngine;

class PlayerVisualInfoStorage : MonoBehaviour
{
	public static PlayerVisualInfoStorage Storage;
	public const int TeamsCount = 4;

	public GameObject [] PlayerPrefabs = new GameObject[TeamsCount];
	public GameObject[] PlayerGemsPrefabs = new GameObject[TeamsCount];
	public Color [] PlayerColors = new Color[TeamsCount];

	void Start()
	{
		Storage = this;
	}

	public static GameObject GetPlayerPrefab(int id)
	{
		return Storage.PlayerPrefabs[id];
	}

	public static GameObject GetGemPrefab(int id)
	{
		return Storage.PlayerGemsPrefabs[id];
	}

	public static Color GetPlayerColor(int id)
	{
		return Storage.PlayerColors[id];
	}
}
