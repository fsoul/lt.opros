
  <tr style="display:none">
    <td align="right"><%e_cms_cons:Id%></td>
    <td>&nbsp;</td>
    <td width="175px"><input readonly="readonly" type="text" class="inputTxt" name="respondent_id_" value="<%:respondent_id_%>" /></td>
    <td>&nbsp;</td>
    <td width="150px">&nbsp;</td>
  </tr>

  <tr>
    <td align="right"><%e_cms_cons:Name%>:</td>
    <td>&nbsp;</td>
    <td><%:first_name_,0,0%></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr class="narrow_text">
    <td valign="top" align="right"><%e_cms_cons:Sex%>:</td>
    <td>&nbsp;</td>

    <td>
        <%iif::sex_,0,<%e_cms_cons:Female%>,<%e_cms_cons:Male%>%>
    </td>

    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>

  <tr class="narrow_text">
    <td align="right"><%e_cms_cons:Birthday%>:</td>
    <td>&nbsp;</td>
    <td><%:birth_date_d%>.<%:birth_date_m%>.<%:birth_date_y%></td>
</tr>

    <tr class="pl">
        <td align="right"><%e_cms_cons:District%>:</td>
        <td>&nbsp;</td>
        <td id="distr_id"></td>
    </tr>
    <!--<tr class="pl">
        <td align="right"><%e_cms_cons:Region%>:</td>
        <td>&nbsp;</td>
        <td id="reg_id"></td>
    </tr>-->
    <tr class="pl">
        <td align="right"><%e_cms_cons:City%>:</td>
        <td>&nbsp;</td>
        <td id="city_id"></td>
    </tr>

  <tr class="reg">
    <td align="right"><%e_cms_cons:District%>:</td>
    <td>&nbsp;</td>
    <td><%text_edit_cms_cons:KYIV_&_SEVASTOPOL%>
      <select disabled class="selector <%iif:<%getError:district_id_%>,,,selector_error%>" name="district_id_" id="selector_district_id" onchange="display_hidden_fields();getOptions('region', this);"
	<%iif:<%getError:district_id_%>,,,style="background: #ff0;"%>

      >
        <%ap_select_district_options:<%:district_id_%>%>
      </select>
    </td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr class="reg">
    <td align="right"><%e_cms_cons:Region%>:</td>
    <td>&nbsp;</td>
    <td><%text_edit_cms_cons:Use other-option to enter own value%>
      <select disabled class="selector <%iif:<%getError:region_%>,,,selector_error%>" name="region_" id="selector_region" onchange="display_hidden_fields();getOptions('city', this);"
	<%iif:<%getError:region_%>,,,style="background: #ff0;"%>

      >
        <%ap_select_region_options:<%:district_id_%>,<%:region_,0,0%>%>
      </select>
    </td>
    <td>&nbsp;</td>
    <td>
        &nbsp;
    </td>
  </tr>
  <tr class="reg">
    <td align="right"><%e_cms_cons:City%>:</td>
    <td>&nbsp;</td>
    <td><%text_edit_cms_cons:Use other-option to enter own value%>
      <select disabled class="selector <%iif:<%getError:city_%>,,,selector_error%>" name="city_" id="selector_city" onchange="display_hidden_fields();"
	<%iif:<%getError:city_%>,,,style="background: #ff0;"%>

      >
        <%ap_select_city_options:<%:region_%>,<%:city_,0,0%>%>
      </select>
    </td>
    <td>&nbsp;</td>
    <td>
        &nbsp;
    </td>
  </tr>

  <tr class="narrow_cstm">

  </tr>


  <tr class="narrow_text">
    <td align="right"><%e_cms_cons:Cellular phone%>:</td>
    <td>&nbsp;</td>
    <td><%:cell_phone_number_%></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>

  <tr class="narrow_text">
    <td align="right"><%e_cms_cons:E-mail%>:</td>
    <td>&nbsp;</td>
    <td><span style="position: relative;"><%:email_%><a style="position:absolute; left:100%; top:-10px; margin-left: 15px" href="/<%iif::language,LT,LT,RU%>/email-change.html" id="changeEmail" class="system_button"><%cms_cons:Change%></a></span></td>
    <td style="position: relative;"><%text_edit_cms_cons:Change%></td>
  </tr>

