<%ap_authorized_only%>

<%ap_email_change%>
<%iif::flag,1,<script>window.location.href = 'http://' + window.location.hostname + '/' + (window.location.pathname).split('/')[1] + '/email-change-success.html' ;</script>%>
<%include:header_internal%>
<%ap_process_edit_profile_form%>
<%iif::flag,0,<%include:email_change_form%>%>
<%include:footer_internal%>