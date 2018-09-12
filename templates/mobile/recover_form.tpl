<div class="reg_form_wrapper m_form">
    <form action="#" autocomplete="off" method="post">
        <div class="s_wrap">
            <div class="section_wrap" data-section="0">
                <p class="head_title">
                    <%e_cms_cons:recover_title%>
                </p>
                <div class="inp_wrap">
                    <label for="new_email"><%e_cms_cons:new_email%></label>
                    <div class="inp_field">
                        <input class="inp" type="email" name="new_email" id="reg_email" placeholder="example@mail.com">
                        <div class="loader invis"></div>
                    </div>
                </div>
                <div class="inp_wrap">
                    <label for="new_pass">
                        <%e_cms_cons:new_pass%>
                    </label>
                    <div class="inp_field">
                        <span class="show_pass_rel">
                            <input name="new_pass" class="inp pass_inp" type="password" id="reg_pass">
                            <div class="show_pass eyeon"></div>
                        </span>
                    </div>
                </div>
                <div class="inp_wrap">
                    <label for="new_pass_confirm">
                        <%e_cms_cons:new_pass_confirm%>

                    </label>
                    <div class="inp_field">
                        <span class="show_pass_rel">
                            <input name="new_pass_confirm" class="inp pass_inp" type="password" id="reg_pass_confirm">
                            <div class="show_pass eyeon"></div>
                        </span>
                    </div>
                </div>
                <div class="g_captcha inp_wrap clearfix">
                    <div class="g-recaptcha" data-sitekey="6Le2_CwUAAAAAOy8xJsc90A3v72lVfSdk4hxnEZd" data-callback="imNotARobot" data-expired-callback="lockSubmit"></div>
                </div>
                <input name="token" type="hidden" value="<%:token%>">
                <div class="submit_btn clearfix">
                    <button id="reg_submit_btn" class="reg_submit_btn submit"><%e_cms_cons:recover%></button>
                </div>
            </div>
        </div>
    </form>
</div>
