<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="dergi_display_all.aspx.cs" Inherits="edergi.dergi_display_all" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
		var selected_row_id = null;
		$(function () {
			var table = $("#dataGrid").jqGrid({
				url: 'data_channels/dergi_list.ashx',
				editurl: 'dergi_display_all.aspx',
				datatype: 'json',
				height: 350,
				colNames: ['Yıl', 'Ay', 'Dosya Adı' ],
				colModel: [
						{ name: 'year', width: 100, sortable: false, editable: true, stype: 'select', edittype: 'select', formatter: 'select',
							editrules: { required: true, number: true, minValue: "1980", maxValue: "2025" },
							editoptions: { value: $.parseJSON(<%=get_availableyears%>), dataUrl: 'data_channels/children.ashx', size: 50} },
							
						{ name: 'month', index: 'owner', width: 150, search: true, sortable: true, editable: true, stype: 'select', edittype: 'select', formatter: 'select',
							editoptions: { value: ":Tüm Aylar;1:Ocak;2:Şubat;3:Mart;4:Nisan;5:Mayıs;6:Haziran;7:Temmuz;8:Ağustos;9:Eylül;10:Ekim;11:Kasım;12:Aralık" } },
													
						{ name: 'path', width: 300, search: true, sortable: true, editable: true, editoptions: { size: 50 }}
                    ],
				rowNum: 10,
				rowList: [10, 20, 30, 50],
				pager: '#DergiGridPager',
				rownumbers: true,
				sortname: 'year',
				viewrecords: true,
				sortorder: 'asc',
				caption: 'Tüm Yayınlar'
			});

			$("#dataGrid").jqGrid('navGrid', '#DergiGridPager',

			{ edit: true, add: true, del: true, search: false },
			// edit options
			{height: 370, width: 470, recreateForm: true, reloadAfterSubmit: true, closeAfterEdit: true, closeOnEscape: true, beforeShowForm: beforeEditFormShown },
			// add options
			{height: 370, width: 470, recreateForm: true, reloadAfterSubmit: true, closeAfterAdd: true, closeOnEscape: true, beforeShowForm: beforeAddFormShown },
			// del options
			{closeOnEscape: true, reloadAfterSubmit: true, width: 289, caption: "Kaydı Sil", msg: "Seçili kayıt(lar)ı silmek istediğinizden emin misiniz?", bSubmit: "Sil", bCancel: "Vazgeç" },
			// search options
			{}

			);
			$("#dataGrid").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true });
			
		});
		function beforeEditFormShown(form)
		{
//			$('#tr_amount', form).hide();

//			dlgDiv = $("#editmoddataGrid");
//			dlgDiv[0].style.top = Math.round((dlgDiv.parent().height()-dlgDiv.height())/2) + "px";
//			dlgDiv[0].style.left = Math.round((dlgDiv.parent().width()-dlgDiv.width())/2) + "px";

//			if( $("#editmoddataGrid select[id=owner] > option").length < 1 )
//			{
//				setTimeout(function() { beforeEditFormShown(form) },10);
//			}
//			else
//			{
//				$("#editmoddataGrid select[id=owner] > option").each(function (i, selected){
//					sel_id = $('#dataGrid').jqGrid('getGridParam', 'selrow');
//					owner = $('#dataGrid').jqGrid('getCell', sel_id, 'owner');

//					opt = selected.innerHTML;
//					opt.replace("&nbsp;", "");
//					owner.replace("&nbsp;", "");
//			
//					if( opt == owner )
//						selected.selected = true;
//				});
//			}
		} 
		function editFormFix(i, selected)
		{
//			sel_id = $('#dataGrid').jqGrid('getGridParam', 'selrow');
//			owner = $('#dataGrid').jqGrid('getCell', sel_id, 'owner');

//			opt = selected.innerHTML;
//			opt.replace("&nbsp;", "");
//			owner.replace("&nbsp;", "");
//			
//			if( opt == owner )
//				selected.selected = true;
		}
		function beforeAddFormShown(form)
		{
//			dlgDiv = $("#editmoddataGrid");
//			dlgDiv[0].style.top = Math.round((dlgDiv.parent().height()-dlgDiv.height())/2) + "px";
//			dlgDiv[0].style.left = Math.round((dlgDiv.parent().width()-dlgDiv.width())/2) + "px";

//			$('#tr_amount', form).show();
//			if( $("#editmoddataGrid select[id=owner] > option").length < 1 )
//			{
//				setTimeout(function() { beforeAddFormShown(form) },10);
//			}
//			else
//			{
//				sec_deg = $("#gview_dataGrid select[id=gs_owner]").find("option:selected").val();
//				$("#editmoddataGrid select[id=owner]").val(sec_deg);
//			}
		}

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
		<div id="mysearch"></div>
		<table id="dataGrid" cellpadding="0" cellspacing="0"></table>
		<div id="DergiGridPager"></div>
    </div>
    </form>
</body>
</html>
