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
        td {
            vertical-align: baseline;
        }

        .reg {
            display: none;
        }

        #respondent_edit_form .pl, #respondent_edit_form .pl td {
            height: 20px;
        }

        .narrow_cstm {
            height: 12px;
        }
    </style>

    <div class="int_b color_<%page_cms:int_b_class%>">
        <div class="int_b_content cstmp">
            <div class="form-item mob-form">

                <table id="respondent_edit_form" border="0">

                    <%setValueOf:respondent_id_,<%ap_get_respondent_id%>%>

                    <input readonly="readonly" type="hidden" class="inp" name="respondent_id_"
                           value="<%:respondent_id_%>"/>

                    <p><%e_cms_cons:Name%>: <%:first_name_,0,0%></p>
                    <p><%e_cms_cons:Sex%>: <%iif::sex_,0,<%e_cms_cons:Female%>,<%e_cms_cons:Male%>%></p>
                    <p><%e_cms_cons:Birthday%>: <%:birth_date_d%>.<%:birth_date_m%>.<%:birth_date_y%></p>

                    <p class="pl"><%e_cms_cons:District%>: <span id="distr_id"></span></p>
                    <p class="pl"><%e_cms_cons:Region%>: <span id="reg_id"></span></p>
                    <p class="pl"><%e_cms_cons:City%>: <span id="city_id"></span></p>

                    <tr class="reg">
                        <td align="right"><%e_cms_cons:District%>:</td>
                        <td>&nbsp;</td>
                        <td><%text_edit_cms_cons:KYIV_&_SEVASTOPOL%>
                            <select disabled class="selector <%iif:<%getError:district_id_%>,,,selector_error%>"
                                    name="district_id_" id="selector_district_id"
                                    onchange="display_hidden_fields();getOptions('region', this);"
                            <%iif:<%getError:district_id_%>,,,style="background: #ff0;"%>

                            >
                            <%ap_select_district_options:<%:district_id_%>%>
                            </select>
                        </td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr class="reg">
                        <td align="right"><%e_cms_cons:Region%>:</td>
                        <td>&nbsp;</td>
                        <td><%text_edit_cms_cons:Use other-option to enter own value%>
                            <select disabled class="selector <%iif:<%getError:region_%>,,,selector_error%>"
                                    name="region_" id="selector_region"
                                    onchange="display_hidden_fields();getOptions('city', this);"
                            <%iif:<%getError:region_%>,,,style="background: #ff0;"%>

                            >
                            <%ap_select_region_options:<%:district_id_%>,<%:region_,0,0%>%>
                            </select>
                        </td>
                        <td>&nbsp;</td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr class="reg">
                        <td align="right"><%e_cms_cons:City%>:</td>
                        <td>&nbsp;</td>
                        <td><%text_edit_cms_cons:Use other-option to enter own value%>
                            <select disabled class="selector <%iif:<%getError:city_%>,,,selector_error%>" name="city_"
                                    id="selector_city" onchange="display_hidden_fields();"
                            <%iif:<%getError:city_%>,,,style="background: #ff0;"%>

                            >
                            <%ap_select_city_options:<%:region_%>,<%:city_,0,0%>%>
                            </select>
                        </td>
                        <td>&nbsp;</td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>

                    <p><%e_cms_cons:Cellular phone%>: <%:cell_phone_number_%></p>

                    <p class="nombtm"><%e_cms_cons:E-mail%>: <%:email_%></p>
                    <a href="/<%iif::language,LT,LT,RU%>/Email-change.html" id="changeEmail" class="button link"><%cms_cons:Change%></a>
                    <p><%text_edit_cms_cons:Change%></p>

                </table>
            </div>
        </div>
    </div>
</div>


<%ap_process_reffer_form%>

<!--<a name="reffer">&nbsp;</a>-->

<%include:page_error%>

<form action="#reffer" method="post" name="reffer" class="m_form">

    <div class="int">

        <%text_edit_page_cms:int_h_class%>
        <div class="int_h color_<%page_cms:int_h_class%>">
            <div class="int_h_text">
                <%e_cms_cons:Reffer form%>
            </div>
        </div>

        <div class="int_b color_<%page_cms:int_b_class%>">
            <div class="int_b_content">
                <div class="mob-form">
                    <p><%text_edit_cms_cons:You can invite friends%><%cms_cons:You can invite friends%></p>
                    <p class="nombtm"><%e_cms_cons:Invitation to email%>:</p>
                    <%text_edit_cms_cons:Enter e-mail in standart format%>
                    <p class="nomargin"><input
                                type="text"
                                class="inp"
                                name="invitation_to_email"
                                value="<%:invitation_to_email%>"
                        <%iif:<%getError:invitation_to_email%>,,,style="background: #ff0;"
                        onkeypress="this.style.background='#fff';"%>
                        title="<%cms_cons:Enter e-mail in standart format%>"
                        />
                    </p>
                    <%text_edit_cms_cons:Send%>
                    <a class="button link" href="javascript:document.forms['reffer'].submit();"><%cms_cons:Send%></a>

                    <%text_edit_cms:reffer_email_subject%>
                    <%html_edit_cms:reffer_email_body%>


                </div>
            </div>
        </div>
        <%text_edit_page_cms:int_b_class%>

    </div>

</form>


<%text_edit_cms_cons:Unsubscribe%>
<%text_edit_cms_cons:Delete registration%>
<%text_edit_cms_cons:Are you sure you unsubscribe%>
<div class="int_h color_<%page_cms:int_h_class%>">
    <div class="int_h_text">
        <%cms_cons:Unsubscribe%>
    </div>
</div>
<div class="mob-form">
    <a class="button link" href="javascript:void(0)" onclick="process_unsubscribe()"><%cms_cons:Delete
        registration%></a>
</div>
<script type="text/javascript">
    function process_unsubscribe() {
        if (confirm("<%cms_cons:Are you sure you unsubscribe%>")) {
            location.href = '<%:EE_HTTP%>action.php?action=user_unsubscribe';
        }
        return false;
    }
</script>

<%include:password_update_form%>

<%include:footer_internal%>