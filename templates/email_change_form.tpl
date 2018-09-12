<form action="#" method="post" name="changeEmail">
    <div class="int form-item">
        <div class="int_h">
            <div class="int_h_text">
                <%cms_cons:Current email%>: <%:email_%>
            </div>
        </div>

        <div class="int_b">
            <div class="int_b_content">
                <div>
                    <%cms_cons:New email%>:
                </div>

                <div class="int_b_text_form center">

                    <input type="hidden" name="respondent_id" value="<%:respondent_id_%>"/>
                    <input type="text" class="inputTxt" id="inputEnterEmail" name="new_email" value="<%post:email_%>" placeholder="<%cms_cons:Login%>"/>
                    <div class="error">
                        <%iif::error,1,<%cms_cons:Error occurred%>%>
                        <%iif::error,2,<%cms_cons:Email already in use%>%>
                    </div>

                </div>

                <div class="int_b_text_submit">

                    <a class="button link" href="javascript:document.forms['changeEmail'].submit();"><%cms_cons:Send%></a>
                </div>
            </div>
        </div>
    </div>
</form>