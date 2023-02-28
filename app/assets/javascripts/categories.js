$(document).ready(function () {
    //*******SET UP TABLE FEATURES**********/
    $('#category-table').DataTable({
        "aaSorting": [],
        columnDefs: [{
        orderable: false,
        targets: 1
        }],
        // "fnInitComplete": function () {
        //   var myCustomScrollbar = document.querySelector('#category-table_wrapper .dataTables_scrollBody');
        //   var ps = new PerfectScrollbar(myCustomScrollbar);
        // },
        "scrollX": true,
    });
    $('#category-table_wrapper').find('label').each(function () {
    $(this).parent().append($(this).children());
    });
    $('#category-table_wrapper .dataTables_filter').find('input').each(function () {
    const $this = $(this);
    $this.attr("placeholder", "Search");
    $this.removeClass('form-control-sm');
    });
    $('#category-table_wrapper .dataTables_length').addClass('d-flex flex-row');
    $('#category-table_wrapper .dataTables_filter').addClass('md-form');
    $('#category-table_wrapper select').removeClass('custom-select custom-select-sm form-control form-control-sm');
    $('#category-table_wrapper select').addClass('mdb-select');
    $('#category-table_wrapper .dataTables_filter').find('label').remove();
});

/************FORM VALIDATION***********/
(function() {
    'use strict';
    window.addEventListener('load', function() {
      // Fetch all the forms we want to apply custom Bootstrap validation styles to
      var forms = document.getElementsByClassName('category_form');
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