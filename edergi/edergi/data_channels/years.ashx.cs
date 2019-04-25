using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using System.Data;

namespace edergiv2.data_channels
{
	/// <summary>
	/// Summary description for children
	/// </summary>
	public class years : IHttpHandler, IRequiresSessionState
	{

		public void ProcessRequest(HttpContext context)
		{

			if (!context.User.Identity.IsAuthenticated)
				return;

			string cmd = "SELECT DISTINCT(year) FROM dergiler";

			DataTable years = sql.query(cmd);
			
			string ret = "<select>";
			for (int i = 0; i < years.Rows.Count; i++)
			{
				ret += "<option value='" + years.Rows[i]["year"].ToString() + "'>" + years.Rows[i]["year"].ToString() + "</option>";
			}
			ret += "</select>";

			context.Response.Write(ret);

		}

		public bool IsReusable
		{
			get
			{
				return false;
			}
		}
	}
}