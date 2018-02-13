<div class="reg_form_wrapper">
    <form action="#" autocomplete="off" method="post">
        <div class="s_wrap">
            <div class="section_wrap">
                <p class="head_title">
                    <%e_cms_cons:recover_title%>
                </p>
                <div class="inp_wrap">
                    <label for="new_email">
                        <%e_cms_cons:new_email%>
                        <input class="inp r_float" type="text" name="new_email" id="reg_email" placeholder="example@mail.com">
                    </label>
                </div>
                <div class="inp_wrap">
                    <label for="new_pass">
                        <%e_cms_cons:new_pass%>
                        <span class="show_pass_rel r_float">
                            <input name="new_pass" class="inp pass_inp" type="password" id="reg_pass">
                            <div class="show_pass eyeon"></div>
                        </span>
                    </label>
                </div>
                <div class="inp_wrap">
                    <label for="new_pass_confirm">
                        <%e_cms_cons:new_pass_confirm%>
                        <span class="show_pass_rel r_float">
                            <input name="new_pass_confirm" class="inp pass_inp" type="password" id="reg_pass_confirm">
                            <div class="show_pass eyeon"></div>
                        </span>
                    </label>
                </div>
                <div class="g_captcha inp_wrap clearfix">
                    <div class="g-recaptcha r_float" data-sitekey="6LcLxjMUAAAAAJLddbOpUD0JchnD4OERO0hM06Zo" data-callback="imNotARobot"></div>
                </div>
                <input name="token" type="hidden" value="<%:token%>">
                <div class="submit_btn clearfix">
                    <button class="reg_submit_btn r_float" disabled><%e_cms_cons:recover%></button>
                </div>
            </div>
        </div>
    </form>
</div>
