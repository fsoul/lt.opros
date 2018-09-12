<%set_allowed_uri_params_list:page_error_flag%>
<%ap_authorized_only%>

<%ap_process_plugin_form2%>

<%include:header_internal_1%>

<div id="page_header">
    <%longtext_edit_page_cms:page_header%>
    <%iif:<%page_cms:page_header%>,,<%:page_description%>,<%page_cms:page_header%>%>
</div>

<script>
    var httpBuildQuery = function(params) {

        if (typeof params === 'undefined' || typeof params !== 'object') {
            params = {};
            return params;
        }

        var query = '?';
        var index = 0;

        for (var i in params) {
            index++;
            var param = i;
            var value = params[i];
            if (index == 1) {
                query += param + '=' + value;
            } else {

                query += '&' + param + '=' + value;
            }
        }
        return query;
    };
    function set_plugin_url(){
        $.ajax({
            url: '/action.php?action=getUrlid'
        }).done(function(data){
            var response = JSON.parse(data);
            var parameters = {
                URLID:  response.urlid,
                Cookie:  localStorage.getItem('cookie'),
                PluginCode:  localStorage.getItem('plid')
            };
            var params = httpBuildQuery(parameters);

            var host = location.host === 'devopros.macc.com.ua' ? 'dev-recruit.mmi.macc.com.ua' : 'recruit.cmeter.com.ua';
            var url = 'http://' + host + '/#additionalUserData'+ params;

            $('#js-additional-data-btn').attr('href', url);
        });
    }
    $(document).ready(function(){
        $('#js-additional-data-btn').click(function(e){
            if($(this).attr('href') == '#'){
                e.preventDefault();
                alert('\u0421\u0441\u044b\u043b\u043a\u0430 \u0435\u0449\u0435 \u043d\u0435 \u0441\u0444\u043e\u0440\u043c\u0438\u0440\u043e\u0432\u0430\u043b\u0430\u0441\u044c, \u043f\u043e\u0432\u0442\u043e\u0440\u0438\u0442\u0435 \u043f\u043e\u043f\u044b\u0442\u043a\u0443 \u0447\u0435\u0440\u0435\u0437 5 \u0441\u0435\u043a\u0443\u043d\u0434.');
            }
        });
    });
</script>
<div id="main_internal_content_center_block_info">
    <%html_edit_page_cms:plugin_error%>
    <%html_edit_page_cms:plugin_sucess%>
    <div id="plugin_error" style="display:none;"><div class="error"><%nl2br_page_cms:plugin_error%></div>
        <script type="text/javascript">function check_agree(){document.getElementById('download_plugin_block').style.display = document.getElementById('agree').checked?'block':'none'}</script>
        <input type="checkbox" name="agree" id="agree" value="agree" onclick="check_agree()"/>
        <%text_edit_page_cms:agree2%><%page_cms:agree2%>
        <div id="download_plugin_block" style="display:none;">
            <%include:<%iif:<%ap_is_plugin_authorized%>,1,ap_plugin_form3_top%>%>
        </div>
        <div class="form_row">
            <%html_edit_page_cms:agree%><%nl2br_page_cms:agree%>
            <br/><br/>
            <!--<br/><br/>
            <%html_edit_page_cms:agree3%><strong><%page_cms:agree3%></strong>-->
        </div>
    </div>
    <div id="plugin_success" style="display:none;">
        <div class="success"><%nl2br_page_cms:plugin_sucess%></div>
        <div>
            <a id="js-additional-data-btn" target="_blank" class="plugin_button button link" href="#">
                <%e_cms_cons:additional_plugin_parameters%>
            </a>
        </div>
    </div>
    <%html_edit_page_cms:page_comment_black00%>
    <%html_edit_page_cms:page_comment_black10%>
    <%html_edit_page_cms:page_comment_black11%>
    <div id="page_comment_black">
        <%nl2br_page_cms:page_comment_black<%ap_is_plugin_authorized%>%>
    </div>
    <%longtext_edit_page_cms:undefined_browser%>
    <%longtext_edit_page_cms:undefined_os%>
    <div id="page_comment">
        <!-- iff: a,b,c,d,e,f   - if(a==b)c elseif(a==d)e else f ?-->
        <%nl2br_page_cms:<%iif:<%ap_get_browser_for_plugin%>,Android,undefined_browser, unknown,undefined_browser,unknown_os,undefined_os,page_comment<%ap_is_plugin_authorized%>%>%>

    </div>
<%include:<%iif:<%ap_get_browser_for_plugin%>,Android,,unknown,,unknown_os,,<%iif:<%ap_is_plugin_authorized%>,1,ap_plugin_form3_inc,ap_plugin_form1_inc%>%>%>
<%include:footer_internal%>
