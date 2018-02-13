<style>
    .password_fields_wrapper{
        padding: 8px;
    }
    .password_fields_wrapper *{
        margin: 4px 0;
    }
</style>
<div class="password_fields_wrapper">
    <div class="">
        <label for="reg_pass">
            <%e_cms_cons:reg_pass%>
        </label>
        <span class="">
            <input name="password" class="inp pass_inp" type="password" id="reg_pass">
            <div class="show_pass"></div>
        </span>
    </div>

    <div class="">
        <label for="reg_pass">
            <%e_cms_cons:reg_pass_confirm%>
        </label>
        <span class="">
            <input name="password_confirm" class="inp pass_inp" type="password" id="reg_pass">
            <div class="show_pass"></div>
        </span>
    </div>
</div>