using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace ChepinMetric
{

	public class CobolProgram
	{

		public struct DivisionCheckResult
		{
			public Boolean IsDivision;
			public String DivisionName;
		}

		public struct CharacterRange
		{
			public Char LeftBorder;
			public Char RightBorder;

			public CharacterRange(Char LeftBorder, Char RightBorder)
			{
				this.LeftBorder = LeftBorder;
				this.RightBorder = RightBorder;
			}
		}

		public struct ChepinMetricValue
		{
			public Int32 [] VariableGroups;
			public Int32 FinalValue;
		}

		public struct VariableOccurence
		{
			public String VariableName;
			public VariableClass Class;
			public Int32 Count;

			public VariableOccurence(String VariableName, VariableClass Class, Int32 Count)
			{
				this.VariableName = VariableName;
				this.Class = Class;
				this.Count = Count;
			}
		}

		public enum VariableClass
		{
			DataVariable,
			FileDescriptor,
			Table
		}

		private const Char NewLineCharacter = '\n';
		private const String NewLineFull = "\r\n";

		private const String EnvironmentDivisionName = "ENVIRONMENT";
		private const String DataDivisionName = "DATA";
		private const String ProcedureDivisionName = "PROCEDURE";
		private const String IdentificationDivisionName = "IDENTIFICATION";

		private const String DivisionTemplatePattern = @"\bDIVISION.";

		private List<String> Lines;
		public Dictionary<String, VariableOccurence> Variables = new Dictionary<String, VariableOccurence>();

		public enum VariableGroup
		{
			IO,
			Modified,
			ControlFlow,
			Parasit
		}

		private Single [] MetricKoefficient = {
			1.0f, 2.0f, 3.0f, 0.5f
		};
		
		List<String> ReservedWords = new List<String>
		{
			"VALUE", "PIC", "SELECT", "ASSIGN", "TO", "IS", "ORGANIZATION", "INDEXED", "FILE", "STATUS",
			"ACCESS", "MODE", "DYNAMIC", "RECORD", "KEY", "WITH", "DUPLICATES", "ALTERNATE", "INDEXED",
			"SECTION", "CONTROLS", "ARE", "FINAL", "PAGE", "LIMIT", "HEADING", "FIRST", "LAST", "DETAIL",
			"FOOTING", "TYPE", "REPORT", "LINE", "COLUMN", "END", "PLUS", "DISPLAY", "NO", "ADVANCING",
			"ACCEPT", "OPEN", "CLOSE", "INPUT", "OUTPUT", "INITIATE", "MOVE", "LOW-VALUES", "START",
			"GREATER", "THAN", "IF", "END-IF", "THEN", "PERFORM", "UNTIL", "THRU", "TABLE", "INVALID",
			"END-START", "READ", "AT", "SET", "END-READ", "TERMINATE", "CLOSE", "STOP", "RUN", "NOT",
			"TRUE", "FALSE", "ZEROS", "EQUAL", "GREATER", "OR", "AND", "NEXT", "END-PERFORM", "FD",
			"FILLER", "SOURCE", "ALL", "GROUP", "RD", "OCCURS", "SEQUENTIAL", "INDICATE", "WORKING-STORAGE",
			"REPORT-FILE", "HIGH-VALUES", "HIGH-VALUE", "SD", "TIMES", "BY", "REDEFINES", "BEGIN",
			"SOURCEFORMAT", "ENVIRONMENT", "DIVISION", "INPUT-OUTPUT", "FILE-CONTROL", "DATA", "PROCEDURE",
			"SORT", "ON", "GIVING", "WRITE", "ASCENDING", "FROM", "AFTER", "LINES", "SPACES", "VARYING",
			"SEARCH", "WHEN", "END-SEARCH", "RELEASE", "COMPUTE", "ROUNDED", "EVALUATE", "ADD", "END-EVALUATE",
			"RETURN", "END-RETURN"
		};

		List<String> IgnoredLinePrefixes = new List<String>
		{
			"FD", "RD", "01"
		};

		const Int32 IndexNotFound = -1;

		Boolean [] IdentifierMask = new Boolean [Byte.MaxValue + 1];

		public CobolProgram()
		{
			BuildIdentifierMask();
		}

		void BuildIdentifierMask()
		{
			for (Int32 Index = 0; Index < IdentifierMask.Length; Index++)
			{
				IdentifierMask [Index] = false;
			}

			CharacterRange [] Ranges = 
			{
				new CharacterRange('0', '9'),
				new CharacterRange('a', 'z'),
				new CharacterRange('A', 'Z')
			};

			foreach (CharacterRange Range in Ranges)
			{
				for (Int32 Character = Range.LeftBorder; Character <= Range.RightBorder; Character++)
				{
					IdentifierMask [Character] = true;
				}
			}

			IdentifierMask ['-'] = true;
			IdentifierMask ['_'] = true;
		}

		public void SetSource(String Source)
		{
			Lines = new List<String>();

			String [] SplitLines = Source.Split(NewLineCharacter);
			foreach (String Line in SplitLines)
			{
				Lines.Add(Line.Trim());
			}

			Preprocessor.PreprocessCode(Lines);
			RemoveIdentificationDivision();

			ParseVariablesList();

			for (Int32 Index = 0; Index <  Lines.Count; Index++)
			{
				Lines [Index] = Lines [Index].ToUpper();
			}
		}

		void RemoveIdentificationDivision()
		{
			Boolean DivisionFound = false;
			for (Int32 Index = 0; Index < Lines.Count; Index++)
			{
				if (!DivisionFound)
				{
					DivisionCheckResult CheckResult = IsDivisionHeader(Lines[Index]);
					if (CheckResult.IsDivision && CheckResult.DivisionName.Equals(IdentificationDivisionName))
					{
						DivisionFound = true;
						Lines.RemoveAt(Index--);
						continue;
					}
				}
				else
				{
					DivisionCheckResult CheckResult = IsDivisionHeader(Lines [Index]);
					if (CheckResult.IsDivision)
					{
						break;
					}
					else
					{
						Lines.RemoveAt(Index--);
					}
				}
			}
		}

		public String GetSourceAsString()
		{
			StringBuilder SourceBuilder = new StringBuilder();

			foreach (String Line in Lines)
			{
				SourceBuilder.Append(Line + NewLineFull);
			}

			return SourceBuilder.ToString();
		}

		List<String> GetEnvironmentDivision()
		{
			return GetDivision(EnvironmentDivisionName);
		}

		List<String> GetDataDivision()
		{
			return GetDivision(DataDivisionName);
		}

		List<String> GetProgramDivision()
		{
			return GetDivision(ProcedureDivisionName);
		}

		List<String> GetDivision(String DivisionName)
		{
			List<String> Division = new List<String>();

			Boolean DivisionFound = false;
			foreach (String Line in Lines)
			{
				if (!DivisionFound)
				{
					DivisionCheckResult CheckResult = IsDivisionHeader(Line);
					if (CheckResult.IsDivision && CheckResult.DivisionName.Equals(DivisionName))
					{
						DivisionFound = true;
						continue;
					}
				}
				else
				{
					DivisionCheckResult CheckResult = IsDivisionHeader(Line);
					if (CheckResult.IsDivision)
					{
						break;
					}
					else
					{
						Division.Add(Line);
					}
				}
			}

			return Division;
		}

		DivisionCheckResult IsDivisionHeader(String Line)
		{
			DivisionCheckResult Result = new DivisionCheckResult();
			Result.IsDivision = false;

			Regex DivisionTemplate = new Regex(DivisionTemplatePattern);

			Match LineMatch = DivisionTemplate.Match(Line);
			if (LineMatch.Success)
			{
				Result.DivisionName = Line.Substring(0, LineMatch.Index).Trim();
				Result.IsDivision = true;
			}

			return Result;
		}

		void ParseVariablesList()
		{
			Variables.Clear();

			foreach (String Line in Lines)
			{
				List<String> LineParts = SplitLineIntoWords(Line);

				if (LineParts.Count > 0)
				{
					if (IgnoredLinePrefixes.Contains(LineParts [0]))
					{
						continue;
					}
				}

				foreach (String Part in LineParts)
				{
					if (Part.Length > 0 && IsValidIdentifier(Part))
					{
						String FilterePart = Part;

						AddVariable(Part);
					}

					if (Part.Equals("PIC"))
					{
						break;
					}
				}
			}
		}

		Boolean IsValidIdentifier(String Word)
		{
			if (!IsReservedWord(Word) && !IsNumber(Word))
			{
				for (Int32 Index = 0; Index < Word.Length; Index++)
				{
					if (Word[Index] >= 0 && Word[Index] < Byte.MaxValue && !IdentifierMask [Word [Index]])
					{
						return false;
					}
				}

				return true;
			}

			return false;
		}

		Boolean IsReservedWord(String Word)
		{
			return ReservedWords.Contains(Word);
		}

		Boolean IsNumber(String Word)
		{
			Int32 Result;
			return Int32.TryParse(Word, out Result);
		}

		public ChepinMetricValue GetChepinMetric()
		{
			ChepinMetricValue MetricValue = new ChepinMetricValue();
			MetricValue.VariableGroups = new Int32 [4];

			MetricValue.VariableGroups [(Byte) VariableGroup.Parasit] = GetParasitVariablesCount();
			MetricValue.VariableGroups [(Byte) VariableGroup.IO] = GetInputVariablesCount();
			MetricValue.VariableGroups [(Byte) VariableGroup.Modified] = GetModifiedVariablesCount();
			MetricValue.VariableGroups [(Byte) VariableGroup.ControlFlow] = GetControlFlowVariablesCount();

			MetricValue.FinalValue = (Int32) (
				MetricKoefficient [0] * MetricValue.VariableGroups [(Byte) VariableGroup.IO] +
				MetricKoefficient [1] * MetricValue.VariableGroups [(Byte) VariableGroup.Modified] +
				MetricKoefficient [2] * MetricValue.VariableGroups [(Byte) VariableGroup.ControlFlow] +
				MetricKoefficient [3] * MetricValue.VariableGroups [(Byte) VariableGroup.Parasit]
			);

			return MetricValue;
		}

		Int32 GetInputVariablesCount()
		{
			String Source = StringListToString(Lines);
			Regex Expression = new Regex(@"\bVALUE\s*");

			MatchCollection Matches = Expression.Matches(Source);

			return Matches.Count;
		}

		Int32 GetModifiedVariablesCount()
		{
			List<String> ProgramDivision = GetProgramDivision();
			List<String> ModifiedVariables = new List<String>();

			List<String> Modifiers = new List<String> {
				"MOVE", "SET"
			};

			foreach (String SourceLine in ProgramDivision)
			{
				List<String> LineParts = SplitLineIntoWords(SourceLine);

				// Find any modifier
				Int32 ModifierIndex = IndexNotFound;
				String FoundModifier = String.Empty;
				Boolean ModifierFound = false;
				foreach (String Modifier in Modifiers)
				{
					ModifierIndex = LineParts.IndexOf(Modifier);
					if (ModifierIndex != IndexNotFound)
					{
						FoundModifier = Modifier;
						ModifierFound = true;
						break;
					}
				}

				String VariableName = String.Empty;
				Boolean VariableDefined = false;
				if (ModifierFound)
				{
					if (LineParts [ModifierIndex].Equals("MOVE") && LineParts.Count >= ModifierIndex + 4)
					{
						VariableName = LineParts [ModifierIndex + 3];
						VariableDefined = true;
					}
					else if (LineParts [ModifierIndex].Equals("SET") && LineParts.Count >= ModifierIndex + 2)
					{
						VariableName = LineParts [ModifierIndex + 1];
						VariableDefined = true;
					}
				}

				if (VariableDefined && !ModifiedVariables.Contains(VariableName))
				{
					ModifiedVariables.Add(VariableName);
				}
			}

			return ModifiedVariables.Count;
		}

		Int32 GetParasitVariablesCount()
		{
			Int32 Result = 0;

			foreach (KeyValuePair<String, VariableOccurence> Variable in Variables)
			{
				// Search variable in code
				if (Variable.Value.Count == 1)
				{
					Result++;
				}
			}

			return Result;
		}

		Int32 GetControlFlowVariablesCount()
		{
			Int32 Result = 0;



			return Result;
		}

		public static String StringListToString(List<String> ListToConvert)
		{
			StringBuilder Builder = new StringBuilder();

			foreach (String Element in ListToConvert)
			{
				Builder.Append(Element + "\r\n");
			}

			return Builder.ToString();
		}

		void AddVariable(String Variable)
		{
			if (Variables.ContainsKey(Variable))
			{
				VariableOccurence Occurence = Variables [Variable];
				Occurence.Count++;
				Variables [Variable] = Occurence;
			}
			else
			{
				VariableOccurence Occurence = new VariableOccurence(Variable, VariableClass.DataVariable, 1);
				Variables.Add(Variable, Occurence);
			}
		}

		List<String> SplitLineIntoWords(String Line)
		{
			Char [] Separators = { '\t', ' ', '.' };
			String [] Parts = Line.Split(Separators);

			List<String> Result = new List<String>();
			foreach (String Part in Parts)
			{
				if (Part.Length > 0)
				{
					Result.Add(Part);
				}
			}

			return Result;
		}

	}

}
