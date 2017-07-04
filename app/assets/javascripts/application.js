//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require editable/bootstrap-editable
//= require editable/rails
//= require select2-full
//= require Chart.bundle
//= require chartkick
//= require bootstrap-datepicker

$( document ).ready(function() {
  //  Enable editable for tags
  $('.editable').editable();

  $('.select2').select2({
      theme: "bootstrap",
      allowClear: true,
      selectOnBlur: true,
      tags: true,
      width: '100%'
  });

  // ransack advenced filter scripts
  $('form').on('click', '.remove_fields', function(event) {
    $(this).closest('.field').remove();
    return event.preventDefault();
  });

  $('form').on('click', '.add_fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    return event.preventDefault();
  });

  // datetime picker date format
  $("#dt1, #dt2").datepicker({
    format: 'dd/mm/yyyy'
  }).on('changeDate', function(ev){
    $('#dt1, #dt2').datepicker('hide');
  });
});

function reply_template_select(){
    $('#body').val($('#reply_email_template').val());
}
