<!-- Facebook Pixel Code -->
<script>
    !function(f,b,e,v,n,t,s)
            {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
            n.callMethod.apply(n,arguments):n.queue.push(arguments)};
            if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
            n.queue=[];t=b.createElement(e);t.async=!0;
            t.src=v;s=b.getElementsByTagName(e)[0];
            s.parentNode.insertBefore(t,s)}(window, document,'script',
        '//connect.facebook.net/en_US/fbevents.js');
    fbq('init', '479654379180135');
    fbq('track', 'PageView');
</script>
<noscript><img height="1" width="1" style="display:none"
               src="//www.facebook.com/tr?id=479654379180135&ev=PageView&noscript=1"
    /></noscript>
<!-- End Facebook Pixel Code -->

<div class="int">

    <%text_edit_page_cms:int_h_class%>
    <div class="int_h color_<%page_cms:int_h_class%>">
        <div class="int_h_text">
            <%page_cms:internal_page_header%>
            <%text_edit_page_cms:internal_page_header%>
        </div>
    </div>

    <div class="int_b color_<%page_cms:int_b_class%>">
        <div class="int_b_content">
            <div>
                <%e_page_cms:internal_page_content%>
            </div>
        </div>
    </div>
    <%text_edit_page_cms:int_b_class%>

</div>
