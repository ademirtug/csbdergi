<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="edergi.Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title></title>
	<link href="css/south-street/jquery-ui-1.8.18.custom.css" rel="stylesheet" type="text/css" />
	<link href="css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
	<link href="css/jquery.metro.css" rel="stylesheet" type="text/css" />

	<script src="jquery.min.js" type="text/javascript"></script>
	<script src="js/jquery-ui-1.8.18.custom.min.js" type="text/javascript"></script>

	<script src="jquery.metro.js" type="text/javascript"></script>
	<script src="js/jquery.jqGrid.js" type="text/javascript"></script>
	<script src="js/jqDnR.js" type="text/javascript"></script>
	<script type="text/javascript">

		$(document).ready(function () {
			$.ajaxSetup({ cache:false });
			
			$("div.metro-pivot").metroPivot();
			$("#login-box").hide();
			
			<%=jscmd%>
		});

		function open_login() {
			$("#login-box").dialog({ height: 280, width: 280, modal: true, closeOnEscape: false,
				open: function(event, ui) { $(".ui-dialog-titlebar-close", ui.dialog).hide(); }
			});
		}
			
		function post_ud() 
		{
			$.post("xlogin.ashx", { "username": $("#username").val(), "password": $("#password").val() },
			function (data) {
				data = $.parseJSON(data);
				if (data.Success == "OK") {
					$("#login-box").dialog("close");
					$('#dergi_display_all').load('dergi_display_all.aspx');
				}
			});
		}

	</script>
</head>
<body accent='blue' theme='light'>
	<form id="default_form" runat="server">
	<div class='page'>
		<div>
			<img src="csb_logo.png" style="float: left" alt="logo" />
			<span style="float: right; font-size: 25pt;" class='accent-color'><br />E-Yayın</span>
			
		</div><br /><br /><br /><br /><br />
		<div id="topbnnr" class='top-banner'></div>
		
		<div id="idx" class='metro-pivot'>
			<div class='pivot-item'>
				<h3><span style="color:Maroon"></span></h3>
				<span id="dergi_display_all"></span>
			</div>
		</div>
	</div>
	<div id="login-box" title="Kullanıcı Girişi" class="ui-dialog-content ui-widget-content">
		<label>
			<span>Kullanıcı</span><br />
			<input id="username" type="text" />
		</label>
		<br />
		<br />
		<label>
			<span>Şifre</span><br />
			<input id="password" type="password" />
		</label>
		<br />
		<br />
		<button id="log_sub" class="submit button" onclick="javascript:post_ud()" type="button">
			Giriş</button>
	</div>
	</form>
</body>
</html>
