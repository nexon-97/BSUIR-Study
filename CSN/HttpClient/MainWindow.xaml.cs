using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using Microsoft.Win32;
using System.IO;
using System.Text;
using System.Collections.Generic;

namespace HttpClient
{
	public partial class MainWindow : Window
	{
        private struct RequestHeaderUI
        {   
            public TextBox HeaderKey;
            public TextBox HeaderValue;
            public Button DeleteButton;
        }

        private int ResponseHeaderItemsDisplayed;
		private Nexon.HttpResponse LastResponse;
        private Nexon.HttpRequest CurrentRequest;

        private List<RequestHeaderUI> RequestHeaderElements;

		public MainWindow()
		{
			InitializeComponent();
		}

		private void WindowLoaded(object sender, RoutedEventArgs e)
		{
			ClearButtonClick(null, null);

            RequestHeaderElements = new List<RequestHeaderUI>();
		}

		private Nexon.HttpRequest GenerateRequest()
		{
            Nexon.HttpRequest Request = new Nexon.HttpRequest(Nexon.RequestMethod.Get);
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

        private RequestHeaderUI AddRequestHeaderItem()
        {
            RequestHeaderUI HeaderItem = new RequestHeaderUI();

            RowDefinition NewRow = new RowDefinition();
            NewRow.Height = new GridLength(1, GridUnitType.Auto);
            RequestHeaderGrid.RowDefinitions.Add(NewRow);

            HeaderItem.HeaderKey = new TextBox()
            {
                Text = "Key",
                FontSize = 16,
                FontWeight = FontWeights.Bold,
                FontFamily = new FontFamily("Roboto"),
                Foreground = new SolidColorBrush(Colors.Black),
                Background = new SolidColorBrush(Color.FromRgb(255, 242, 181)),
                Padding = new Thickness(5),
                Margin = new Thickness(1)
            };
            Grid.SetRow(HeaderItem.HeaderKey, RequestHeaderElements.Count);
            Grid.SetColumn(HeaderItem.HeaderKey, 0);

            HeaderItem.HeaderValue = new TextBox()
            {
                Text = "Value",
                FontSize = 16,
                FontFamily = new FontFamily("Roboto"),
                Foreground = new SolidColorBrush(Colors.Black),
                Background = new SolidColorBrush(Color.FromRgb(197, 255, 193)),
                Padding = new Thickness(5),
                Margin = new Thickness(1)
            };
            Grid.SetRow(HeaderItem.HeaderValue, RequestHeaderElements.Count);
            Grid.SetColumn(HeaderItem.HeaderValue, 1);

            HeaderItem.DeleteButton = new Button()
            {
                Content = "X",
                FontSize = 16,
                FontWeight = FontWeights.Bold,
                Foreground = new SolidColorBrush(Colors.Red),
                Padding = new Thickness(5),
                Margin = new Thickness(1)
            };
            HeaderItem.DeleteButton.Click += DeleteHeaderLineClick;

            Grid.SetRow(HeaderItem.DeleteButton, RequestHeaderElements.Count);
            Grid.SetColumn(HeaderItem.DeleteButton, 2);

            RequestHeaderGrid.Children.Add(HeaderItem.HeaderKey);
            RequestHeaderGrid.Children.Add(HeaderItem.HeaderValue);
            RequestHeaderGrid.Children.Add(HeaderItem.DeleteButton);

            RequestHeaderElements.Add(HeaderItem);
            return HeaderItem;
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

                if (LastResponse.AttachedContent != null)
                {
                    Nexon.HttpContent.ContentType ResponseContentType = LastResponse.AttachedContent._ContentType;
                    Dialog.FilterIndex = (int)ResponseContentType + 1;

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

        private void AttachFileButtonClick(object sender, RoutedEventArgs e)
		{
		    if (CurrentRequest == null)
            {
                CurrentRequest = new Nexon.HttpRequest(Nexon.RequestMethod.Get);
            }

            OpenFileDialog Dialog = new OpenFileDialog();
            Dialog.CheckPathExists = true;
            Dialog.Title = "Choose file path and name";
            Dialog.Filter = "Any File|*.*";
            Dialog.FilterIndex = 1;

            if (Dialog.ShowDialog() == true)
            {
                string FileName = Dialog.FileName;

                byte[] FileData = File.ReadAllBytes(FileName);
                CurrentRequest.AttachedContent = new Nexon.HttpContent(FileData);
                CurrentRequest.AttachedContent._Encoding = Encoding.UTF8;

                if (CurrentRequest.AttachedContent.CheckContentType() == Nexon.HttpContent.ContentType.PlainText)
                {
                    AttachedContentData.Text = CurrentRequest.AttachedContent.StringRepresentation;
                }
                else
                {
                    AttachedContentData.Text = "[BINARY DATA]";
                }
            }
		}

        private void ClearAttachedFileButtonClick(object sender, RoutedEventArgs e)
        {
            CurrentRequest = null;
            AttachedContentData.Text = string.Empty;

            RequestHeaderGrid.Children.Clear();
            RequestHeaderElements.Clear();
        }

        private void AddHeaderClick(object sender, RoutedEventArgs e)
        {
            AddRequestHeaderItem();
        }

        private void DeleteHeaderLineClick(object sender, RoutedEventArgs e)
        {
            foreach (var Candidate in RequestHeaderElements)
            {
                if (Candidate.DeleteButton == sender)
                {
                    RequestHeaderGrid.Children.Remove(Candidate.HeaderKey);
                    RequestHeaderGrid.Children.Remove(Candidate.HeaderValue);
                    RequestHeaderGrid.Children.Remove(Candidate.DeleteButton);
                }
            }

            RefreshRequestHeaderGrid();
        }

        private void RefreshRequestHeaderGrid()
        {
            int Index = 0;
            foreach (var Item in RequestHeaderElements)
            {
                Grid.SetRow(Item.HeaderKey, Index);
                Grid.SetColumn(Item.HeaderKey, 0);
                Grid.SetRow(Item.HeaderValue, Index);
                Grid.SetColumn(Item.HeaderValue, 1);
                Grid.SetRow(Item.DeleteButton, Index);
                Grid.SetColumn(Item.DeleteButton, 2);

                Index++;
            }
        }
	}
}
