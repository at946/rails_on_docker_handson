$(function() {
  $("#visible_password").change(function() {
    type = "password"
    if ($(this).prop("checked")) { 
      type = "text"
    }
    $("#user_password").attr("type", type)
  })
})