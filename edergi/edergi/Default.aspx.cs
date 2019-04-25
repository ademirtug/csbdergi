using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Web.Profile;

namespace edergi
{
	public partial class Default : System.Web.UI.Page
	{
		public string jscmd = "";
		public string usr = "";

		protected void Page_Load(object sender, EventArgs e)
		{
			if (Session["log"] == null || Session["log"].ToString() != "x")
			{
				jscmd += " open_login(); \r\n";
			}
			else
			{
				jscmd = "$('#dergi_display_all').load('dergi_display_all.aspx');";
			}


			//if (User.Identity.IsAuthenticated)
			//{
			//    usr = User.Identity.Name + " - <a href='javascript:logout();'>Çıkış</a> ";
			//    jscmd = "$('#dergi_display_all').load('dergi_display_all.aspx');";
			//}
			//else
			//{
			//    usr = "<a href='javascript:open_login();'>Giriş</a>";
			//    jscmd += "open_login();";
			//}

								
		}
	}
}