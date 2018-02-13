<%ap_authorized_only%>

<%include:header_internal%>
<%include:main_register_js%>

<%ap_process_edit_profile_form%>

<script type="text/javascript" src="<%:EE_HTTP%>js/respondent.js"></script>

<a name="edit_profile">&nbsp;</a>

<%include:page_error%>

<div class="int">

<%text_edit_page_cms:int_h_class%>
    <div class="int_h color_<%page_cms:int_h_class%>">
        <div class="int_h_text">
        <%cms_cons:Registration form%>
        </div>
    </div>

    <style>
        td{
            vertical-align: baseline;
        }
        .reg{
            display: none;
        }
        #respondent_edit_form .pl, #respondent_edit_form .pl td{
            height: 20px;
        }
        .cstmp{
            padding: 15px 12px 2px 0 !important;
        }
        .narrow_cstm{
            height: 12px;
        }
    </style>
   <div class="int_b color_<%page_cms:int_b_class%>">
        <div class="int_b_content cstmp">
            <div class="form-item">

                <table id="respondent_edit_form" border="0">

                <%setValueOf:respondent_id_,<%ap_get_respondent_id%>%>

                <%include:ap_respondent_profile%>

                </table>
            </div>
        </div>
    </div>
</div>

<%text_edit_cms_cons:Unsubscribe%>
<%text_edit_cms_cons:Delete registration%>
<%text_edit_cms_cons:Are you sure you unsubscribe%>
<div class="int_h color_<%page_cms:int_h_class%>">
    <div class="int_h_text">
        <%cms_cons:Unsubscribe%>
    </div>
</div><br>
<a class="button link" href="javascript:void(0)" onclick="process_unsubscribe()"><%cms_cons:Unsubscribe%></a>
<script type="text/javascript">
    function process_unsubscribe() {
        if(confirm('<%cms_cons:Are you sure you unsubscribe%>')) {
            location.href = '<%:EE_HTTP%>action.php?action=user_unsubscribe';
        }
        return false;
    }
</script>
<br>
<%include:password_update_form%>

<%include:footer_internal%>

