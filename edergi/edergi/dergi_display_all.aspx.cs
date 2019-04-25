using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.SqlServer.Types;

namespace edergi
{
	public partial class dergi_display_all : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!User.Identity.IsAuthenticated)
				return;

			string cmd = Request.Form["oper"] != null ? Request.Form["oper"].ToString() : "";

			switch (cmd)
			{
				case "del":
					{
						del_pc_record();
					}
					break;
				case "add":
					{
						add_pc_record();
					}
					break;
				case "edit":
					{
						edit_pc_record();
					}
					break;
				default:
					break;
			}
		}

		public void del_pc_record()
		{
			string[] idarray = Request.Form["id"].ToString().Split(',');

			foreach (string id in idarray)
				sql.execute("delete from dergiler where id=" + id);
		}


		public void add_pc_record()
		{
			DataTable pcs = sql.query_schema("SELECT * FROM dergiler ", true);

			DataRow r = pcs.NewRow();
			r["year"] = Request.Form["year"];
			r["month"] = Request.Form["month"];
			r["path"] = Request.Form["path"];


			pcs.Rows.Add(r);

			sql.update(pcs);
		}

		public void edit_pc_record()
		{
			string id = Request.Form["id"];

			DataTable pcs = sql.query("SELECT * FROM dergiler where id=" + id, true);

			if (pcs.Rows.Count < 1)
				return;
		
			pcs.Rows[0]["year"] = Request.Form["year"];
			pcs.Rows[0]["month"] = Request.Form["month"];
			pcs.Rows[0]["path"] = Request.Form["path"];

			sql.update(pcs);
		}

		public string get_availableyears
		{
			get
			{
				string cmd = @"SELECT DISTINCT(year) FROM dergiler";

				DataTable years = sql.query(cmd);

				string ret = "'{";
				for (int i = 0; i < years.Rows.Count; i++)
				{
					ret += "\"" + years.Rows[i]["year"].ToString() + "\":\"" + years.Rows[i]["year"].ToString() + "\",";
				}

				if( ret.Length > 2 )
					ret = ret.Remove(ret.Length - 1);
				ret += "}'";

				return ret;
			}
		}
	}
}