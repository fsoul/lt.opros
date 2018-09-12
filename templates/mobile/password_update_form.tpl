<%ap_process_new_password_update_form%>

<%include:change_pass_js%>

<div class="reg_form_wrapper m_form">
    <p class="head_title"><%e_cms_cons:Password update form%></p>
    <form method="POST" autocomplete="off">
        <div class="s_wrap">
            <div class="section_wrap" data-section="0">

                <div class="inp_wrap">
                    <label for="reg_email">
                        <%e_cms_cons:Old password%>
                        <input name="old_pass" class="inp " type="password" id="old_pass">
                    </label>
                    <div class="loader invis"></div>
                </div>

                <div class="inp_wrap">
                    <label for="reg_pass">
                        <%e_cms_cons:New password%>
                            <span class="show_pass_rel">
                                <input name="passw" class="inp pass_inp" type="password" id="reg_pass">
                                <div class="show_pass eyeon"></div>
                            </span>
                    </label>
                </div>
                <div class="inp_wrap">
                    <label for="reg_pass_confirm">
                        <%e_cms_cons:Confirm password%>
                            <span class="show_pass_rel">
                                <input class="inp pass_inp" type="password" id="reg_pass_confirm">
                                <div class="show_pass eyeon"></div>
                            </span>
                    </label>
                </div>

                <div class="g_captcha inp_wrap">
                    <div class="g-recaptcha " data-sitekey="6LcLxjMUAAAAAJLddbOpUD0JchnD4OERO0hM06Zo" data-callback="imNotARobot"></div>
                </div>
            </div>

            <div class="submit_btn">
                <button id="reg_submit_btn" class="reg_submit_btn"><%e_cms_cons:upd_submit%></button>
            </div>
            <input type="hidden" value="<%:email_%>" id="resp_email">
        </div>
    </form>
</div>
