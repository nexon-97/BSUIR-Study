using System.IO;

public struct LevelStats
{
	public bool Available;
	public bool Passed;
	public int Minutes;
	public int Seconds;
	public int Stars;
}

public class PlayerInfo
{
	public int LeftTeam;
	public int RightTeam;
	public string Name;

	public LevelStats [] LevelsInfo;

	public bool LevelAvailable(int index)
	{
		return LevelsInfo[index].Available;
	}

	public bool LevelPassed(int index)
	{
		return LevelsInfo[index].Passed;
	}

	public void SaveToFile()
	{
		string[] Lines = new string[LevelsInfo.Length + 3];
		Lines[0] = Name;
		Lines[1] = LeftTeam.ToString();
		Lines[2] = RightTeam.ToString();
		for (int i = 0; i < LevelsInfo.Length; i++)
		{
			Lines[3 + i] = string.Format("{0}|{1}|{2}|{3}|{4}",
				(LevelsInfo[i].Available ? "+" : "-"),
				(LevelsInfo[i].Passed ? "+" : "-"),
				LevelsInfo[i].Stars,
				LevelsInfo[i].Minutes,
				LevelsInfo[i].Seconds
			);
		}

		File.WriteAllLines(string.Format(@"Data\Players\{0}.dat", Name), Lines);
	}
}
