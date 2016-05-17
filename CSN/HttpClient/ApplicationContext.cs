namespace Nexon
{
	public class ApplicationContext
	{
		#region Singleton part
		private static ApplicationContext _instance;

		private ApplicationContext()
		{
			ActiveClient = new HttpClient();
		}

		public static ApplicationContext Instance
		{
			get
			{
				if (_instance == null)
				{
					_instance = new ApplicationContext();
				}

				return _instance;
			}
		}
		#endregion

		#region Properties
		public HttpClient ActiveClient;
		#endregion
	}
}
