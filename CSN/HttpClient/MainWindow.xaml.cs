using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace HttpClient
{
	public partial class MainWindow : Window
	{
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
			Context.ActiveClient.ConnectToServer(HostName);

			Nexon.HttpRequest Request = GenerateRequest();
			Nexon.HttpResponce Responce = Context.ActiveClient.SendRequest(Request);

			ResponceTextField.Text = Responce.RawResponce;
		}
	}
}
