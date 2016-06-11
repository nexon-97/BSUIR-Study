using UnityEngine;
using UnityEngine.UI;

public class SoundController : MonoBehaviour
{
	public GameObject Source;
	public Sprite MutedSprite;
	public Sprite UnmutedSprite;

	private AudioSource SourceSound;

	void Start()
	{
		SourceSound = Source.GetComponent<AudioSource>();

		LevelManager.CreateInstance();

		SourceSound.volume = GameSettings.ActiveSettings.SoundVolume;
		if (GameSettings.ActiveSettings.EnableSound)
		{
			Unmute();
		}
		UpdateImage();
	}

	public void Mute()
	{
		SourceSound.mute = true;
		UpdateImage();

		UpdateGameSettings(!SourceSound.mute);
	}

	public void Unmute()
	{
		SourceSound.mute = false;
		UpdateImage();

		UpdateGameSettings(!SourceSound.mute);
	}

	public void Switch()
	{
		SourceSound.mute = !SourceSound.mute;
		UpdateImage();

		UpdateGameSettings(!SourceSound.mute);
	}

	public void UpdateGameSettings(bool EnableSound)
	{
		GameSettings.ActiveSettings.EnableSound = EnableSound;
		GameSettings.Update();
	}

	public void SetVolume(float volume)
	{
		SourceSound.volume = volume;
	}

	public void UpdateImage()
	{
		if (MutedSprite != null && UnmutedSprite != null)
		{
			gameObject.GetComponent<Image>().sprite = (SourceSound.mute) ? MutedSprite : UnmutedSprite;
			Vector2 size = new Vector2((SourceSound.mute) ? 52.0f : 30.0f, 30.0f);
			gameObject.GetComponent<RectTransform>().sizeDelta = size;
		}
	}
}
