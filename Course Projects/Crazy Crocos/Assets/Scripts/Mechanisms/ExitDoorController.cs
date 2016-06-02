﻿using UnityEngine;
using System.Collections;

public class ExitDoorController : MonoBehaviour
{
	private PlayerController[] Controllers = new PlayerController[2];
	private bool [] PlayerInside = new bool[2];

	void OnTriggerEnter2D(Collider2D collided)
	{
		if (collided.gameObject.tag.Equals("Player"))
		{
			PlayerController controller = collided.gameObject.GetComponent<MonoBehaviour>() as PlayerController;
			if (controller != null)
			{
				int TeamId = LevelController.GetInstance().GetTeamLocalId(controller.Team);
				PlayerInside[TeamId] = true;
				Controllers[TeamId] = controller;

				if (PlayerInside[0] && PlayerInside[1])
				{
					LevelController.GetInstance().SetLevelCompleted();

					foreach (var item in Controllers)
					{
						item.DisableMovement = true;
					}
				}
			}
		}
	}

	void OnTriggerExit2D(Collider2D collided)
	{
		if (collided.gameObject.tag.Equals("Player"))
		{
			PlayerController controller = collided.gameObject.GetComponent<MonoBehaviour>() as PlayerController;
			if (controller != null)
			{
				int TeamId = LevelController.GetInstance().GetTeamLocalId(controller.Team);
				PlayerInside[TeamId] = false;
				Controllers[TeamId] = null;
			}
		}
	}
}