using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using Microsoft.Win32;
using System.IO;

namespace HttpClient
{
	public partial class MainWindow : Window
	{
        private int ResponseHeaderItemsDisplayed;
		private Nexon.HttpResponse LastResponse;

		public MainWindow()
		{
			InitializeComponent();
		}

		private void WindowLoaded(object sender, RoutedEventArgs e)
		{
			ClearButtonClick(null, null);
		}

		private Nexon.HttpRequest GenerateRequest()
		{
			Nexon.HttpRequest Request = new Nexon.HttpRequest();
			Request.ConnectionType = Nexon.ConnectionType.KeepAlive;
			Request.Host = HostNameInput.Text;
			Request.Method = Nexon.RequestMethod.Get;
			Request.Page = ResourceNameInput.Text;

			return Request;
		}

		private void SendServerRequestClick(object sender, RoutedEventArgs e)
		{
			Nexon.ApplicationContext Context = Nexon.ApplicationContext.Instance;
			string HostName = HostNameInput.Text;

            ClearResponseHeaderTab();

			bool ConnectionResult = Context.ActiveClient.ConnectToServer(HostName);
            if (ConnectionResult)
            {
                Nexon.HttpRequest Request = GenerateRequest();
				LastResponse = Context.ActiveClient.SendRequest(Request);

                ResponceTextField.Text = LastResponse.ToString();
                LoadResponseHeaderOnScreen(LastResponse);
            }
		}

        private void LoadResponseHeaderOnScreen(Nexon.HttpResponse Response)
        {
            foreach (var Item in Response.ResponseValues)
            {
                AddResponseHeaderItem(Item.Key, Item.Value);
            }

			ResponseCode.Text = string.Format("{0} - {1}", Response.ServerStateCode.ToString(), Response.ServerStateCodeDesc);
		}

        private void ClearResponseHeaderTab()
        {
            ResponceHeaderGrid.Children.Clear();
            ResponseHeaderItemsDisplayed = 0;
        }

        private void AddResponseHeaderItem(string Key, string Value)
        {
            RowDefinition NewRow = new RowDefinition();
            NewRow.Height = new GridLength(1, GridUnitType.Auto);
            ResponceHeaderGrid.RowDefinitions.Add(NewRow);

            TextBlock KeyTextBlock = new TextBlock()
            {
                Text = Key,
                FontSize = 16,
                FontWeight = FontWeights.Bold,
                FontFamily = new FontFamily("Roboto"),
                Foreground = new SolidColorBrush(Colors.Black),
                Background = new SolidColorBrush(Color.FromRgb(255, 242, 181)),
                Padding = new Thickness(5),
                Margin = new Thickness(1)
            };
            Grid.SetRow(KeyTextBlock, ResponseHeaderItemsDisplayed);
            Grid.SetColumn(KeyTextBlock, 0);

            TextBlock ValueTextBlock = new TextBlock()
            {
                Text = Value,
                FontSize = 16,
                FontFamily = new FontFamily("Roboto"),
                Foreground = new SolidColorBrush(Colors.Black),
                Background = new SolidColorBrush(Color.FromRgb(197, 255, 193)),
                Padding = new Thickness(5),
                Margin = new Thickness(1)
            };
            Grid.SetRow(ValueTextBlock, ResponseHeaderItemsDisplayed);
            Grid.SetColumn(ValueTextBlock, 1);     

            ResponceHeaderGrid.Children.Add(KeyTextBlock);
            ResponceHeaderGrid.Children.Add(ValueTextBlock);

            ResponseHeaderItemsDisplayed++;
        }

		private void ClearButtonClick(object sender, RoutedEventArgs e)
		{
			ResponceTextField.Text = string.Empty;
			ClearResponseHeaderTab();
			LastResponse = null;
			ResponseCode.Text = string.Empty;
		}

		private void SaveToFileButtonClick(object sender, RoutedEventArgs e)
		{
			if (LastResponse != null)
			{
				SaveFileDialog Dialog = new SaveFileDialog();
				Dialog.CheckPathExists = true;
				Dialog.OverwritePrompt = true;
				Dialog.Title = "Choose file path and name";
				Dialog.Filter = "Binary File (*.bin)|*.bin|Text File (*.txt)|*.txt";

				Nexon.HttpContent.ContentType ResponseContentType = LastResponse.AttachedContent._ContentType;
				Dialog.FilterIndex = (int) ResponseContentType + 1;

				if (Dialog.ShowDialog() == true)
				{
					string FileName = Dialog.FileName;

					switch (ResponseContentType)
					{
						case Nexon.HttpContent.ContentType.Binary:
							File.WriteAllBytes(FileName, LastResponse.AttachedContent._Data);
							break;
						case Nexon.HttpContent.ContentType.PlainText:
							File.WriteAllText(FileName, LastResponse.AttachedContent.StringRepresentation);
							break;
					}
				}
			}
		}
	}
}
