<%row%

<div class="int gray">

<%text_edit_page_cms:int_h_class%>
  <div class="int_h color_<%page_cms:int_h_class%>">
    <div class="int_h_text">
      <%:project_name%>
    </div>
  </div>

  <div class="int_b color_<%page_cms:int_b_class%>">
    <div class="int_b_content">
      <div class="current_projects_points">
          <%text_edit_cms_cons:Investigation points%>
          <%iif::project_max_point,,,0,,<%cms_cons:Investigation points%> - <span class="s1 project_points"><%ap_project_points_label::project_max_point%></span>.%>
      </div>
      <div class="current_projects_description">
          <%:project_description%>
      </div>
      <div class="current_projects_link">
<%text_edit_cms_cons:Take part in investigation%>
        <a class="system_button" href="<%:survey_url%>"><%cms_cons:Take part in investigation%></a>
      </div>
    </div>
  </div>
<%text_edit_page_cms:int_b_class%>

</div>


%row%>

<%row_empty%

<div class="int">

  <div class="int_h color_<%page_cms:int_h_class%>">
    <div class="int_h_text">
<%longtext_edit_page_cms:empty_row_header%>
    </div>
  </div>

  <div class="int_b color_<%page_cms:int_b_class%>">
    <div class="int_b_content">
<%e_page_cms:empty_row%>
    </div>
  </div>

</div>

%row_empty%>
