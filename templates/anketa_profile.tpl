<%set_allowed_uri_params_list:ID%>
<%set_allowed_uri_params_list:poll_id%>
<%set_allowed_uri_params_list:resp_id%>

<%ap_process_profile_pool%>
<%include:head%>

<%include:anketa_profile_<%iif::error,1,error,form%>%>

<%include:foot%>
