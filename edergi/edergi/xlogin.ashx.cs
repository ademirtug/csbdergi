using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.Script.Serialization;
using System.Data;
using System.Web.SessionState;

namespace edergiv2
{
	/// <summary>
	/// Summary description for xlogin
	/// </summary>
	public class xlogin : IHttpHandler, IRequiresSessionState
	{
		public void ProcessRequest(HttpContext context)
		{
			HttpRequest r = context.Request;
			xlogin_response rsp = new xlogin_response();

			string u = r["username"];
			string p = r["password"];

			if (u == "sa" && p == "1")
			{
				//success
				rsp.Success = "OK";
				context.Session["log"] = "x";
			}
			else
			{
				//fail
				rsp.Success = "FAIL";
				rsp.Message = "Bilgilerinizi tekrar kontrol edin";
			}

			string sr = (new JavaScriptSerializer()).Serialize(rsp);
			context.Response.Write(sr);
		}

		public bool IsReusable
		{
			get
			{
				return false;
			}
		}
	}

	public class xlogin_response
	{
		public string Success;
		public string Message;
		public string Command;
	}

}