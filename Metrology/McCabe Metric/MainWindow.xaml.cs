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
using System.Text.RegularExpressions;

namespace Metrics {

	public partial class MainWindow : Window {

		CCode CodeSample = new CCode();

		public MainWindow() {
			InitializeComponent();
		}

		void ExitButton_Click(Object sender, RoutedEventArgs e) {
			Application.Current.Shutdown();
		}

		void OpenFileButton_Click(Object sender, RoutedEventArgs e) {
			OpenFileDialog dialog = new OpenFileDialog();
			dialog.Filter = "C Source File (*.c)|*.c";

			if (dialog.ShowDialog() == true) {
				try {
					CodeTextBox.Text = File.ReadAllText(dialog.FileName);
					SetStatusBarText(String.Format("Файл \"{0}\" загружен", dialog.FileName));
				} catch (Exception) {
					SetStatusBarText("Ошибка чтения файла");
				}
			}
		}

		void SetStatusBarText(String state) {
			StatusBarText.Text = state;
		}

		void CountCodeMetric(Object sender, RoutedEventArgs e) {
			try {
				PreproccessorPass(null, null);

				CodeSample.Code = CodeTextBox.Text;
				OrientedGraph Graph = CodeSample.BuildControlFlowGraph();

				CodeSample.CountMetrics(MetricsText);
				CodeSample.PrintDocument();
			} catch (Exception) {
				MessageBox.Show("Бедняжка...\nКто-то не сдал Огороднику лабу, кто-то будет бухать с горя :3", "УПС");
			}
		}

		void PreproccessorPass(Object sender, RoutedEventArgs e) {
			CodeTextBox.Text = Preprocessor.PreprocessCode(CodeTextBox.Text);
		}

		Int32 CountMetricValue(Int32 ArcCount, Int32 VertexCount, Int32 ConnectivityComponents) {
			const Int32 MetricHardLinkKoefficient = 2;
			return (ArcCount - VertexCount + MetricHardLinkKoefficient * ConnectivityComponents);
		}
	}
}
