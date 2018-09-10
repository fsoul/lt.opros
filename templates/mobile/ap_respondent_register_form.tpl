<%set_allowed_uri_params_list:reffer_email_%>

<%ap_process_registration_form%>

<%include:header_internal_1%>

<div class="textBlock clearfix">
    <img src="/img/social.png" class="mainPageImg">
    <%longtext_edit_page_cms:join_us%>
    <%nl2br_page_cms:join_us%>
</div>


<a href="<%get_href:Authorization,LT%>" class="button wht"><%e_cms_cons:Enter%></a>
<%text_edit_cms_cons:Or%>
<div class="center"> <%e_cms_cons:Or%> </div>
<a href="/<%iif::language,LT,LT,EN%>/registration.html" class="button wht"><%e_cms_cons:Register btn%></a>


<div id="main_internal_content_center_block_info">
    <%include:page_error%>

    <%include:ap_ajax_selectors%>

    <script type="text/javascript" src="<%:EE_HTTP%>js/respondent.js"></script>


