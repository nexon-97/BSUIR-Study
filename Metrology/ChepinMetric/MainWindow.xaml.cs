using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Microsoft.Win32;
using System.IO;

namespace ChepinMetric
{

	public partial class MainWindow : Window
	{

		public MainWindow()
		{
			InitializeComponent();
		}

		private void OnOpenSourceCode(Object sender, RoutedEventArgs e)
		{
			OpenFileDialog Dialog = new OpenFileDialog();
			Dialog.Filter = "COBOL Source File (*.cbl)|*.cbl";

			if (Dialog.ShowDialog() == true)
			{
				try
				{
					CodeTextBox.Text = File.ReadAllText(Dialog.FileName);
					FilePathTextBox.Text = Dialog.FileName;
				}
				catch (Exception)
				{
					MessageBox.Show("Ошибка чтения файла!", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
				}
			}
		}

		private void OnCheckMetric(Object sender, RoutedEventArgs e)
		{
			CobolProgram Program = new CobolProgram();
			Program.SetSource(CodeTextBox.Text);

			StringBuilder OutputText = new StringBuilder();
			foreach (String Variable in Program.VariablesOriginal)
			{
				OutputText.Append(Variable + "\r\n");
			}

			CobolProgram.ChepinMetricValue MetricValue = Program.GetChepinMetric();
			OutputText.Append("\r\n" +
				"Вводимые: " + MetricValue.VariableGroups [(Byte) CobolProgram.VariableGroup.IO] + "\r\n" +
				"Модифицируемые: " + MetricValue.VariableGroups [(Byte) CobolProgram.VariableGroup.Modified] + "\r\n" +
				"Управляющие: " + MetricValue.VariableGroups [(Byte) CobolProgram.VariableGroup.ControlFlow] + "\r\n" +
				"Паразитные: " + MetricValue.VariableGroups [(Byte) CobolProgram.VariableGroup.Parasit] + "\r\n" + 
				"Значение метрики: " + MetricValue.FinalValue + "\r\n");

			MetricInfoTextBox.Text = "Список переменных (в верхнем регистре):\r\n" + OutputText.ToString();
		}

	}

}
