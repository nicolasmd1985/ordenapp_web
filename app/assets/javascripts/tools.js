$(document).ready(function () {

  $('#cancel_search_tools').css('cursor', 'pointer');
  $('#cancel_search_tools').click(function(){
    var lng = document.documentElement.lang;
    $('#search').val('');
    $('#tools-filter-form #status').val('');
    $('#tools-filter-form #tecnic').val('');
    if (lng == "es") {
      $('#filterbar > #tools-filter-form > div:last-child > div:nth-child(2) > div > input').val('Estado');
      $('#filterbar > #tools-filter-form > div:last-child > div:nth-child(3) > div > input').val('Técnico');
    } else {      
      $('#filterbar > #tools-filter-form > div:last-child > div:nth-child(2) > div > input').val('Status');
      $('#filterbar > #tools-filter-form > div:last-child > div:nth-child(3) > div > input').val('Tecnic');
    }
  });


  //*******SET UP TABLE FEATURES**********/
    $('#tool-table').DataTable({
        "aaSorting": [],
        columnDefs: [{
        orderable: false
        }],
        "scrollX": true,
      });
    $('#tool-table_wrapper').find('label').each(function () {
      $(this).parent().append($(this).children());
    });
    $('#tool-table_wrapper .dataTables_filter').find('input').each(function () {
      const $this = $(this);
      $this.attr("placeholder", "Search");
      $this.removeClass('form-control-sm');
    });
    $('#tool-table_wrapper .dataTables_length').addClass('d-flex flex-row');
    $('#tool-table_wrapper .dataTables_filter').addClass('md-form');
    $('#tool-table_wrapper select').removeClass('custom-select custom-select-sm form-control form-control-sm');
    $('#tool-table_wrapper select').addClass('mdb-select');
    $('#tool-table_wrapper .dataTables_filter').find('label').remove();

    /****************LIMIT TEXT LENGTH ON TABLE******************/
  $(".limitado").each(function() {
    var max_chars = 15;
    limit_text = $(this).text();
    if (limit_text.length > max_chars) {
      limit = limit_text.substr(0, max_chars)+" ...";
      $(this).text(limit);
    }
  });
});

/************FORM VALIDATION***********/
(function() {
  'use strict';
  window.addEventListener('load', function() {
    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    var forms = document.getElementsByClassName('tool_form');
    // Loop over them and prevent submission
    var validation = Array.prototype.filter.call(forms, function(form) {
      form.addEventListener('submit', function(event) {
        if (form.checkValidity() === false) {
          event.preventDefault();
          event.stopPropagation();
        }
        form.classList.add('was-validated');
      }, false);
    });
  }, false);
})();
