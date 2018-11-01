<%ap_process_new_registration_form%>

<%include:header%>

<%include:main_register_js%>

<%include:page_error%>

<div class="reg_form_wrapper m_form">
    <div class="m_visuals">
        <img src="/img/visuals/RegForm_1_Step_Sign_up.jpg" alt="">
        <img src="/img/visuals/RegForm_2_Step_Plugin.jpg" alt="">
        <img src="/img/visuals/RegForm_3_Step_Profile.jpg" alt="">
    </div>
    <div class="mobile_register_prolog">
        <%e_page_cms:head_prolog%>
    </div>
    <p class="head_title"><%e_cms_cons:head_title%></p>
    <p class="head_title_hint"><%e_cms_cons:head_title_hint%></p>
    <form method="POST" autocomplete="off">
        <input type="hidden" name="tns_id" id="tns_id" value="">
        <div class="s_wrap">
            <div class="section_wrap" data-section="0">
                <p class="sub_title">1. <%e_cms_cons:profile_data%></p>
                <div class="inp_wrap">
                    <label for="reg_email"><%e_cms_cons:reg_email%></label>
                    <div class="inp_field">
                        <input name="email" class="inp" type="email" placeholder="example@mail.com" id="reg_email" autocomplete="off">
                        <div class="loader invis"></div>
                    </div>
                </div>
                <div class="inp_wrap">
                    <label for="reg_pass"><%e_cms_cons:reg_pass%></label>
                    <div class="inp_field">
                        <span class="show_pass_rel">
                            <input name="passw" class="inp pass_inp" type="password" id="reg_pass">
                            <div class="show_pass eyeon"></div>
                        </span>
                    </div>
                </div>
                <div class="inp_wrap">
                    <label for="reg_pass_confirm"><%e_cms_cons:reg_pass_confirm%></label>
                    <div class="inp_field">
                        <span class="show_pass_rel">
                            <input class="inp pass_inp" type="password" id="reg_pass_confirm">
                            <div class="show_pass eyeon"></div>
                        </span>
                    </div>
                </div>
                <!--<div class="submit_btn">
                    <button id="first_btn" class="reg_submit_btn submit nextStep"><%e_cms_cons:reg_step_1%></button>
                </div>-->
            </div>

            <div class="section_wrap" data-section="1">
                <p class="sub_title">2. <%e_cms_cons:profile_info%></p>
                <div class="inp_wrap">
                    <label for="reg_name">
                        <%e_cms_cons:reg_name%>
                    </label>
                    <div class="inp_field">
                        <input name="first_name" class="inp" type="text" id="reg_name">
                        <input name="last_name" type="hidden" value="last_name">
                    </div>
                </div>
                <div class="inp_wrap">
                    <span>
                        <%e_cms_cons:reg_gender%>
                    </span>
                    <div class="inp_field">
                        <div class="r_inp_group">
                            <div class="i_block cstm_radio">
                                <label for="reg_gender_male">
                                    <%e_cms_cons:reg_gender_male%>
                                    <input name="sex" type="radio" id="reg_gender_male" value="1">
                                    <div class="check"></div>
                                </label>
                            </div>
                            <div class="i_block cstm_radio">
                                <label for="reg_gender_female">
                                    <%e_cms_cons:reg_gender_female%>
                                    <input name="sex" type="radio" id="reg_gender_female" value="0">
                                    <div class="check"></div>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="inp_wrap">
                    <label for="reg_birthdate">
                        <%e_cms_cons:reg_bd%>
                    </label>
                    <div class="inp_field">
                        <input name="birth_date" class="inp" type="date" id="reg_birthdate" placeholder="<%e_cms_cons:bd_placeholder%>">
                    </div>
                </div>
                <!--<div class="submit_btn">
                    <button class="reg_submit_btn submit nextStep"><%e_cms_cons:reg_step_2%></button>
                </div>-->
            </div>

            <div class="section_wrap" data-section="2">
                <p class="sub_title">3. <%e_cms_cons:profile_contacts%></p>
                <div class="inp_wrap">
                    <label for="reg_phone">
                        <%e_cms_cons:reg_phone%>
                    </label>
                    <div class="inp_field">
                        <!--<input name="cell_phone_number" class="inp" type="tel" placeholder="+370" id="reg_phone" maxlength="13">-->
                        <input name="cell_phone_number" class="inp" type="tel" placeholder="+370" id="reg_phone">
                        <div class="loader invis"></div>
                    </div>
                </div>
                <div class="inp_wrap">
                    <label for="reg_residence">
                        <%e_cms_cons:reg_residence%>
                    </label>
                    <div class="inp_field">
                        <select name="city" id="reg_residence_id" class="inp r_float">
                            <option value="..."><%cms_cons:reg_resid_placeholder%></option>
                            <%get_city_list:1,<%:language%>%>
                        </select>
                    </div>
                    <!--<div class="inp_field">
                        <div class="search_wrap">
                            <input class="inp" type="text" placeholder="<%e_cms_cons:reg_resid_placeholder%>" id="reg_residence">
                            <input name="city" type="hidden" id="reg_residence_id">
                            <ul class="cityList invis">
                                <input type="text" autocomplete="off" id="search_inp"/>
                                <div class="search_hint"><%e_cms_cons:search_hint%></div>
                                <div class="li_wrap"></div>
                            </ul>
                        </div>
                    </div>-->
                </div>
                <div class="inp_wrap">
                    <label for="reg_how">
                        <%e_cms_cons:reg_how%>
                    </label>
                    <div class="inp_field">
                        <select name="dic_know_about_us_id" class="inp" id="know_about">
                            <%ap_select_know_about_options:<%:language%>%>
                        </select>
                    </div>
                    <div class="inp_textarea invis">
                        <input value="" id="refer_email" class="inp" name="refer_email" type="text" placeholder="Friend's Email">
                    </div>
                    <div class="inp_textarea invis">
                        <textarea name="dic_know_about_us_other" id="know_about_another" placeholder="<%e_cms_cons:enter_text%>"></textarea>
                    </div>
                </div>
                <div class="user_agreement">
                    <%include:agreement_rules_<%iif::language,LT,lt,ru%>%>
                </div>
                <div class="user_personal_data_agreement m_user_persoanl_data_arg">
                    <%include:agreement__personal_rules_lt%>
                </div>
                <div class="g_captcha inp_wrap">
                    <div class="g-recaptcha" data-sitekey="6LdxTikUAAAAAFm4XSMA6R-gJuzYqCP4U5nY2gGI" data-callback="imNotARobot"></div>
                </div>
            </div>
            <div class="submit_btn">
                <button id="reg_submit_btn" class="reg_submit_btn unlock"><%e_cms_cons:reg_step_1%></button>
            </div>
        </div>
    </form>
</div>
<%include:<%iif:<%ap_process_check_referrer%>,1,fix_refer%>%>
<%longtext_edit_page_cms:email_subject%>
<%longtext_edit_page_cms:email_body%>
<%include:footer%>