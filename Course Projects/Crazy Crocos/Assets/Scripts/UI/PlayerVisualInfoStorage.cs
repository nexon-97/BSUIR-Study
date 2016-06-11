using UnityEngine;

class PlayerVisualInfoStorage : MonoBehaviour
{
	public static PlayerVisualInfoStorage Storage;
	public const int TeamsCount = 4;

	public GameObject[] PlayerPrefabs;
	public GameObject[] PlayerGemsPrefabs;

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
}
