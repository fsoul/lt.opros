<html>
<head>
	<title>Website pages metatags import</title>
	<link rel=stylesheet href="<%:EE_HTTP%>css/admin_panel_style.css" type="text/css" />
	<script type="text/javascript" src="<%:EE_HTTP%>js/cookie.js"></script>
</head>

<body>
<div id="seo" style="margin: 2px 10px;">
<div style="height:31px" class="header">Metatags import</div>
<form
	method="POST"
	enctype="multipart/form-data" 
	action="<%:EE_ADMIN_URL%><%:modul%>.php?op=import_from_csv"
	name="form1"
	onSubmit="
		if (this.csv_file.value.substr(this.csv_file.value.length-3).toLowerCase() != 'csv')
		{
			alert ('Please, select .csv-file...');
			return false;
		}
	"
>

<input type="hidden" name="refresh" value="yes">
<br />
Select .csv-file for import:
<br />
<br />
<input type="file" name="csv_file" size="50" />
<br />
<br />

<div class="error"><%getError:csv_file%></div>





<%iif:<%config_var:use_draft_content%>,1,
<%iif:<%getError:csv_file%>,,
<div class="ee_notice">
	<strong>
		<span class="error">You are in draft mode!</span><br />
		For apply changes in the SEO immediately after the import\\, select the following checkbox <br />
		<br />
		<input type="checkbox" id="publish_seo" name="publish_seo" style="vertical-align: middle;" onclick="setCookie('seo-publish_status'\\, this.checked\\, '<%:EE_HTTP_PREFIX%>');" />Publish changes in SEO<br />
		<script type="text/javascript">
			if (getCookie('seo-publish_status')) {
				document.getElementById('publish_seo').checked = (getCookie('seo-publish_status') == 'true' ? true : false);
			}
		</script>
		<br />
		If you leave checkbox nonselected You can publish changes in <i>"Assets Management"</i> by clicking on the button to "Publish" -> "All"
	</strong>
</div>,
%>
%>
<br />
<input onclick="window.parent.closePopup('<%iif:<%getError:csv_file%>,,no,yes%>'); return false;" style="cursor: hand" type="button" accessKey="<%CONSTANT:BUT_ACCESS_KEY_CLOSE%>" value="<%CONSTANT:BUT_LABEL_CLOSE%>" name="back" class="button">&nbsp;
<%include:buttons/btn_import%>
<br />
<br />
</form>



</div>
</body>

</html>