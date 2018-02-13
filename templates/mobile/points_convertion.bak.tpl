<%ap_authorized_only%>
<%set_allowed_uri_params_list:success%>

<%ap_process_points_convertion_form%>

<%include:header_internal%>

<div id="points_on_account"><%include:ap_account_state%></div>

<br/><%text_edit_cms_cons:Conversion successful%>
<div style="color:#00A600;"><%iif::error,,<%iif:<%get:success%>,1,<%cms_cons:Conversion successful%><br/><br/>%>%></div>
<%include:page_error%>
<%text_edit_cms_cons:Your account %s points%>

<script type="text/javascript" language="JavaScript">

    function start_convertion(p_id)
    {
        var f_ar = new Array ("replenishment_mobile", "replenishment_webmoney", "project_help");

        var i;

        if (p_id == "")
        {
//		alert('<%cms_cons:Select convertion type%>');
            document.getElementById('points_convertion_type').focus();

            for(i=0; i<f_ar.length; i++)
            {
                f = document.getElementById(f_ar[i]);

                if (f.style.display != "none")
                {
                    document.getElementById('pass_' + f_ar[i]).value = '';

                    f.style.display = "none";
                }
            }
        }
        else
        {
            var f = document.getElementById(p_id);

            if (f.style.display == "none")
            {
                f.style.display = "";
            }

            for(i=0; i<f_ar.length; i++)
            {
                if (f_ar[i] != p_id)
                {
                    document.getElementById('pass_' + f_ar[i]).value = '';

                    f = document.getElementById(f_ar[i]);

                    f.style.display = "none";
                }
            }
        }
    }
</script>


<form name="points_convertion" id="points_convertion" method="post" action="<%get_href::t%>">
    <div class="form-item">


        <%text_edit_cms_cons:Points number should be at least %s%>
        <%text_edit_cms_cons:You can not use more then %s points number%>
        <%text_edit_cms_cons:Points number should be divisible by %s%>


        <div class="int" id="points_using">

            <%text_edit_page_cms:int_h_class%>
            <div class="int_h color_<%page_cms:int_h_class%>">
                <div class="int_h_text">
                    <%e_cms_cons:Points using%>
                </div>
            </div>

            <div class="int_b color_<%page_cms:int_b_class%>">
                <div class="int_b_content">

                    <div class="form_row">
                        <div class="form_label_long">
                            <%e_cms_cons:Enter points number you wish to convert%>
                        </div>

                        <div class="form_input">
                            <%text_edit_cms_cons:Min %s\, max %s\, divisible by %s%>
                            <input type="text" class="inputTxt" id="inputPointsNumber" name="points_number" value="<%post:points_number%>"
                                   title="<%inputPointsNumberTitle%>"
                            <%iif:<%getError:points_number%>,,,style="background: #ff0;" onkeypress="this.style.background='#fff';"%>
                            />
                        </div>
                    </div>

                    <div class="form_row">
                        <div class="form_label_long">
                            <%e_cms_cons:Select points convertion type%>
                        </div>

                        <div class="form_input">

                            <%text_edit_cms_cons:Post order%>
                            <%text_edit_cms_cons:Replenishment mobile%>
                            <%text_edit_cms_cons:Replenishment WebMoney%>
                            <%text_edit_cms_cons:Project Investigation of children%>

                            <select name="points_convertion_type" id="points_convertion_type"
                                    onchange="start_convertion(document.forms['points_convertion'].points_convertion_type.value);"
                            >

                                <!-- %dic_score_convert_type_list% -->

                                <option value=""></option>
                                <option value="replenishment_mobile" <%iif:<%post:points_convertion_type%>,replenishment_mobile,selected="selected"%>><%cms_cons:Replenishment mobile%></option>
                                <option value="replenishment_webmoney" <%iif:<%post:points_convertion_type%>,replenishment_webmoney,selected="selected"%>><%cms_cons:Replenishment WebMoney%></option>
                                <option value="project_help" <%iif:<%post:points_convertion_type%>,project_help,selected="selected"%>><%cms_cons:Project Investigation of children%></option>
                                <!-- -->
                            </select>

                        </div>
                    </div>

                </div>
            </div>
            <%text_edit_page_cms:int_b_class%>

        </div>


        <%include:int_points_convertion_repl_mobile_form%>

        <%include:int_points_convertion_repl_webmoney_form%>

        <%include:int_points_convertion_project_help_form%>
    </div>
</form>



<%include:footer_internal%>