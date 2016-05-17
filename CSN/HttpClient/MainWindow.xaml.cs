using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

namespace HttpClient
{
	public partial class MainWindow : Window
	{
        private int ResponseHeaderItemsDisplayed;

		public MainWindow()
		{
			InitializeComponent();
		}

		private void WindowLoaded(object sender, RoutedEventArgs e)
		{
			Nexon.ApplicationContext Context = Nexon.ApplicationContext.Instance;
		}

		private Nexon.HttpRequest GenerateRequest()
		{
			Nexon.HttpRequest Request = new Nexon.HttpRequest();
			Request.ConnectionType = Nexon.ConnectionType.KeepAlive;
			Request.Host = HostNameInput.Text;
			Request.Method = Nexon.RequestMethod.Get;
			Request.Page = "/index.php";

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
                Nexon.HttpResponce Response = Context.ActiveClient.SendRequest(Request);

                ResponceTextField.Text = Response.ToString();

                LoadResponseHeaderOnScreen(Response);
            }
		}

        private void LoadResponseHeaderOnScreen(Nexon.HttpResponce Response)
        {
            foreach (var Item in Response.ResponceValues)
            {
                AddResponseHeaderItem(Item.Key, Item.Value);
            }
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
	}
}
