using UnityEngine;
using UnityEngine.UI;

public class CrocoOverlayController : MonoBehaviour
{
	public Slider RChannelSlider;
	public Slider GChannelSlider;
	public Slider BChannelSlider;

	private bool AttachedToSliders;
	private Image _image;
	private SpriteRenderer _sprite;

	private void Start ()
	{
		_image = GetComponent<Image>();
		_sprite = GetComponent<SpriteRenderer>();
		AttachedToSliders = (RChannelSlider != null && GChannelSlider != null && BChannelSlider != null);
	}

	public void UpdateColor()
	{
		if (AttachedToSliders)
		{
			Color newColor = new Color(RChannelSlider.value / 255.0f, GChannelSlider.value / 255.0f, BChannelSlider.value / 255.0f);
			if (_image != null)
			{
				_image.color = newColor;
			}
			else if (_sprite != null)
			{
				_sprite.color = newColor;
			}
		}
	}
}
