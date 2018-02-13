<%include:google_analytics%>
<%include:<%iif:<%ap_is_respondent_authorized%>,0,<%iif::page_file,ap_respondent_register_form,cookie_js,cookie_js_short%>,cookie_js%>%>
<script type='text/javascript'>
    var _tnsBanners = _tnsBanners || [];
    _tnsBanners.push({
        'banner': '#test_logo',
        'id':'test_logo'
    });
    _tnsBanners.push({
        'banner': '#test_footer',
        'id':'test_footer'
    });
    if ($('#test_flash').length > 0) {
        _tnsBanners.push({
            'banner': 'test_flash',
            'id':'test_flash'
        });
    }

    (function () {
        var tv = document.createElement('script');
        tv.type = 'text/javascript';
        tv.async = true;
        tv.src = '../js/viewability.js';
        var s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(tv, s);
    })()
</script>
</body>
</html>
