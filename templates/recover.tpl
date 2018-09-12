<%ap_process_recover_access%>

<%include:header_internal_1%>

<%include:main_register_js%>

<style>
    .recover_wrap{
        max-width: 600px;
    }
</style>

<%include:recover_<%iif:<%getError:page_error_flag%>,1,error,form%>%>

<%include:footer%>