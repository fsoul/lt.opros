<ul class="parent_ul">
    <li class="parent <%iif:<%:sat%>,1,hidden%>"><%getValueOf:open%><%getValueOf:label%></li>
    <ul class="<%iif:<%:sat%>,1,home,child%>">
        <%get_menu_level:100,2,templates/menu/mob_menu_l2.tpl,templates/menu/mob_menu_l2.tpl,,<%ap_is_respondent_authorized%>,,,<%:sat%>%>
    </ul>
</ul>