<%include:head%>
<div id="iPageOutline">
<header>
    <div class="row">
        <div class="block90">
            <!--<div class="lang">
                <span class="lang-item">
                    <%iif::language,UA,UA,RU%>
                </span>
                <div class="lang-drop">
                    <a class="lang-href" href="<%get_href::t,UA%>">UA</a>
                    <a class="lang-href" href="<%get_href::t,RU%>">RU</a>
                </div>
            </div>-->
            <h1 class="logo block25">
                <a href="/" title="TNS"><img src="/img/tns-logo.jpg" alt="TNS"></a>
            </h1>
            <!--<ul class="language block75">
                <li class="block50 right <%iif::language,UA,active%>"><a href="<%get_href::t,UA%>"><%e_cms_cons:Ukr%></a></li>
                <li class="seperator"></li>
                <li class="block50 <%iif::language,RU,active%>"><a href="<%get_href::t,RU%>"><%e_cms_cons:Rus%></a></li>
            </ul>-->
        </div>
        <!--<%*//fix_bug_opera_mini%>-->
        <!--<ul class="navigation">
            <%get_menu_level:10,1,templates/menu/top_active.tpl,templates/menu/top_inactive.tpl,templates/menu/top_separator.tpl,<%ap_is_respondent_authorized%>%>
            <%include:<%iif:<%ap_is_respondent_authorized%>,0,forgot_password_link%>%>
            <li>
                <form class="log-<%iif:<%ap_is_respondent_authorized%>,0,in,out%>" name="header_login" action="<%get_href:Authorization%>" method="post" autocomplete="off">
                    <%include:ap_respondent_log<%iif:<%ap_is_respondent_authorized%>,0,in,out%>_form%>
                </form>
            </li>
        </ul>-->

        <div class="block10">
            <div>
                <div id="menu-toggle-show"></div>
            </div>
        </div>
    </div>
    <!-- <div id="main-menu" class="clearfix">
        <div id="menu-toggle-hide"></div>
        <ul class="menu" id="nav1">
            <%get_menu_level:100,1,templates/menu/tabs_active.tpl,templates/menu/tabs_inactive.tpl,,<%ap_is_respondent_authorized%>%>
        </ul>
        <ul class="menu" id="nav2">
            <%get_menu_level:100,2,templates/menu/tabs_active.tpl,templates/menu/tabs_inactive.tpl,,<%ap_is_respondent_authorized%>%>
        </ul>
    </div> -->

    <style>
        #main-menu #nav1{
            position: relative;
        }
        .home li a{
            position: absolute;
            left: 7px;
            top: 18px;
        }
        .parent, .home li a{
            color: #FF69A5;
            font-weight: bold;
        }
        .parent{
            padding: 10px 0 10px 22px !important;
        }
        .parent:before{
            content: '+';
            color: black;
            padding-right: 5px;
        }
        .open:before{
            content: '-';
            color: black;
            padding-right: 5px;
            font-size: 18px;
        }
        .child{
            display: none;
        }
        .child li {
            padding: 5px 0 5px 22px !important;
        }
        .hide{
            display: none;
        }
        .mobile_logout{
            margin: 0 0 15px 22px;
        }
        .mobile_logout .exit, .mobile_logout .enter{
            text-decoration: none;
            color: #FF69A5;
            font-weight: bold;
        }
    </style>

    <div id="main-menu" class="clearfix">
        <div id="menu-toggle-hide"></div>
        <ul class="menu" id="nav1">
            <%get_menu_level:100,1,templates/menu/mob_menu_a.tpl,templates/menu/mob_menu_i.tpl,,<%ap_is_respondent_authorized%>%>
        </ul>
        <div class="mobile_logout">
            <%iif:<%Ap_is_respondent_authorized%>,1,<span id="btnLogout"><%text_edit_cms_cons:Exit%><a class="exit" href="javascript:document.forms['header_login'].submit();"><%cms_cons:Exit%></a></span>,<a class="enter" href="/<%:language%>/Authorization.html"><%cms_cons:Enter%></a>%>
        </div>
    </div>
    <form class="log-out" name="header_login" action="/RU/Authorization.html" method="post" autocomplete="off">
        <input type="hidden" name="page_from" value="<%get_href:<%:t%>%>" />
        <input type="hidden" name="action" value="respondent_logout" />
    </form>
    <script>

    (function(){
        var l = '<%:language%>';
        if(l == 'RU'){
            $('.home li a').text('\u0413\u043b\u0430\u0432\u043d\u0430\u044f');
        }

        $('.parent').click(function(e){
            var $this = $(e.target);
            var $child = $this.siblings('.child');
            $('.parent').removeClass('open');
            $('.child').hide();
            $('.parent').removeClass('open');
            $this.addClass('open');
            $child.show();
        });
        //$('#nav2').appendTo('#nav1 .here');

        var $toggleShow = $('#menu-toggle-show'),
            $menu = $('#main-menu'),
            $toggleHide = $('#menu-toggle-hide');
        $toggleShow.on('click', function () {
            $('.child').hide();
            $('.here').addClass('open');
            $('.child').siblings('.here').siblings('ul').show();
            $toggleShow.hide();
            $menu.show();
            $toggleHide.show();
        });
        $('#menu-toggle-hide').on('click', function () {
            $('.parent').removeClass('open');
            $toggleShow.show();
            $menu.hide();
            $toggleHide.hide();
        });
    })();

    </script>
</header>