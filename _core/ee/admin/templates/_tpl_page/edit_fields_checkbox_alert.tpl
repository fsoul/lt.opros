<input <%iif::readonly,,,readonly%> type="checkbox" name="<%:field_name%>" <%iif:<%:<%:field_name%>%>,1,checked%> value="1" onchange="check_box_alert(this, 'draft_content')">