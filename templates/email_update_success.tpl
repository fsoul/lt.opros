<%ap_email_update_success%>

<%include:header_internal%>

<div id="main_internal_content_" class="grid-8">
    <div id="page_header">
        <%iif::flag,0,<%cms_cons:Email has been changed%>,<%cms_cons:Email already in use%>%>
        <%iif::flag,2,<%cms_cons:Error occurred%>%>
    </div>
    <div id="main_internal_content_center_block_info">

        <div id="page_comment_black">
        </div>

        <div id="page_comment">

        </div>
        <div class="int">


            <div class="int_h color_">
                <div class="int_h_text">


                </div>
            </div>

            <div class="int_b color_">
                <div class="int_b_content">
                    <div>

                    </div>
                </div>
            </div>
        </div>
    </div>
<%include:footer_internal%>