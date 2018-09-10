<%set_allowed_uri_params_list:reffer_email_%>

<%ap_process_new_registration_form%>

<%include:header_internal_1%>

<%include:main_register_js%>

<%include:page_error%>

<!-- Facebook Pixel Code -->
<script>
    !function(f,b,e,v,n,t,s)
            {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
            n.callMethod.apply(n,arguments):n.queue.push(arguments)};
            if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
            n.queue=[];t=b.createElement(e);t.async=!0;
            t.src=v;s=b.getElementsByTagName(e)[0];
            s.parentNode.insertBefore(t,s)}(window, document,'script',
        'https://connect.facebook.net/en_US/fbevents.js');
    fbq('init', '479654379180135');
    fbq('track', 'PageView');
</script>
<noscript><img height="1" width="1" style="display:none"
               src="https://www.facebook.com/tr?id=479654379180135&ev=PageView&noscript=1"
    /></noscript>
<!-- End Facebook Pixel Code -->

<div class="reg_form_wrapper">
    <p class="head_title"><%e_cms_cons:head_title%></p>
    <p class="head_title_hint"><%e_cms_cons:head_title_hint%></p>
    <form method="POST" autocomplete="off">
        <input type="hidden" name="tns_id" id="tns_id" value="">
        <div class="s_wrap">
            <div class="section_wrap">
                <p class="sub_title">1. <%e_cms_cons:profile_data%></p>
                <div class="inp_wrap">
                    <label for="reg_email">
                        <%e_cms_cons:reg_email%>
                        <input name="email" class="inp r_float" type="text" placeholder="example@mail.com" id="reg_email" autocomplete="off">
                    </label>
                    <div class="loader invis"></div>
                </div>
                <div class="inp_wrap">
                    <label for="reg_pass">
                        <%e_cms_cons:reg_pass%>
                        <span class="show_pass_rel r_float">
                            <input name="passw" class="inp pass_inp" type="password" id="reg_pass">
                            <div class="show_pass eyeon"></div>
                        </span>
                    </label>
                </div>
                <div class="inp_wrap">
                    <label for="reg_pass_confirm">
                        <%e_cms_cons:reg_pass_confirm%>
                        <span class="show_pass_rel r_float">
                            <input class="inp pass_inp" type="password" id="reg_pass_confirm">
                            <div class="show_pass eyeon"></div>
                        </span>
                    </label>
                </div>
            </div>

            <div class="section_wrap">
                <p class="sub_title">2. <%e_cms_cons:profile_info%></p>
                <div class="inp_wrap">
                    <label for="reg_name">
                        <%e_cms_cons:reg_name%>
                        <input name="first_name" class="inp r_float" type="text" id="reg_name">
                        <input name="last_name" type="hidden" value="last_name">
                    </label>
                </div>
                <div class="inp_wrap">
                    <span>
                        <%e_cms_cons:reg_gender%>
                        <div class="r_inp_group r_float">
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
                    </span>
                </div>
                <div class="inp_wrap">
                    <label for="reg_birthdate">
                        <%e_cms_cons:reg_bd%>
                        <input name="birth_date" class="inp r_float" type="text" id="reg_birthdate" placeholder="<%cms_cons:bd_placeholder%>">
                    </label>
                </div>
            </div>

            <div class="section_wrap">
                <p class="sub_title">3. <%e_cms_cons:profile_contacts%></p>
                <div class="inp_wrap">
                    <label for="reg_phone">
                        <%e_cms_cons:reg_phone%>
                        <input value="" id="reg_phone" class="inp r_float" name="cell_phone_number" type="text" placeholder="+370">
                    </label>
                    <div class="loader invis"></div>
                </div>
                <div class="inp_wrap">
                    <label for="reg_residence">
                        <%e_cms_cons:reg_residence%>
                        <select name="city" id="reg_residence_id" class="inp r_float">
                            <option value="..."><%cms_cons:reg_resid_placeholder%></option>
                            <%get_city_list:1,<%:language%>%>
                        </select>
                        <!--<div class="search_wrap">
                            <input class="inp r_float" type="text" placeholder="<%cms_cons:reg_resid_placeholder%>" id="reg_residence">
                            <input name="city" type="hidden" id="reg_residence_id">
                            <ul class="cityList invis">
                                <input type="text" autocomplete="off" id="search_inp"/>
                                <div class="search_hint"><%e_cms_cons:search_hint%></div>
                                <div class="li_wrap"></div>
                            </ul>
                        </div>-->
                    </label>
                </div>
                <div class="inp_wrap">
                    <label for="reg_how">
                        <%e_cms_cons:reg_how%>
                        <select name="dic_know_about_us_id" class="inp r_float" id="know_about">
                            <%ap_select_know_about_options:<%:language%>%>
                        </select>
                    </label>
                    <div class="inp_textarea r_float invis">
                        <textarea name="dic_know_about_us_other" id="know_about_another" placeholder="<%cms_cons:enter_text%>"></textarea>
                    </div>
                    <div class="clearfix"></div>
                </div>
            </div>

            <div class="g_captcha inp_wrap clearfix">
                <div class="g-recaptcha r_float" data-sitekey="6LdxTikUAAAAAFm4XSMA6R-gJuzYqCP4U5nY2gGI" data-callback="imNotARobot" data-expired-callback="captchaExpired"></div>
            </div>
            <div class="user_agreement">
                <%include:agreement_rules_<%iif::language,LT,lt,ru%>%>
            </div>
            <div class="submit_btn">
                <button class="reg_submit_btn r_float" id="reg_submit_btn" disabled><%e_cms_cons:reg_submit%></button>
            </div>
        </div>
    </form>
</div>
<%longtext_edit_page_cms:email_subject%>
<%longtext_edit_page_cms:email_body%>
<%include:footer%>

