<div class="reg_form_wrapper">
        <div class="s_wrap">
            <div class="section_wrap">
                <p class="head_title">
                    <%e_cms_cons:recover_title%>
                </p>

                <div id="page_error" class="error">
                    <p><%getError:email%></p>
                    <p><%getError:pass%></p>
                    <p><%getError:pass_confirm%></p>
                    <p><%iif:<%getError:incorrect_link%>,1,<%e_cms_cons:incorrect_link%>%></p>
                </div>
            </div>
        </div>
    </div>
</div>