$(document).ready(function(){

  $("#export_csv, #export_excel").click(function(e){
    $("#"+ e.target.id).addClass("not_continue");
  })

  $('#cancel_search').click(function(){
    var lng = document.documentElement.lang;
    $('#search').val('');
    $('#orders-filter-form #city').val('');
    $('#orders-filter-form #tecnic').val('');
    $('#orders-filter-form #customer').val('');
    $('#orders-filter-form #status').val('');
    $('#orders-filter-form #sync').val('');
    if (lng == "es") {      
      $('#filterbar > #orders-filter-form > div:last-child > div:first-child > div:nth-child(2) input').val('Ciudad');
      $('#filterbar > #orders-filter-form > div:last-child > div:nth-child(2) > div:first-child input').val('Usuario');
      $('#filterbar > #orders-filter-form > div:last-child > div:nth-child(2) > div:nth-child(4) input').val('Cliente');
      $('#filterbar > #orders-filter-form > div:last-child > div:nth-child(3) > div:first-child input').val('Estado');
      $('#filterbar > #orders-filter-form > div:last-child > div:nth-child(3) > div:nth-child(4) input').val('Sincronización');
    } else {      
      $('#filterbar > #orders-filter-form > div:last-child > div:first-child > div:nth-child(2) input').val('City');
      $('#filterbar > #orders-filter-form > div:last-child > div:nth-child(2) > div:first-child input').val('User');
      $('#filterbar > #orders-filter-form > div:last-child > div:nth-child(2) > div:nth-child(4) input').val('Customer');
      $('#filterbar > #orders-filter-form > div:last-child > div:nth-child(3) > div:first-child input').val('Status');
      $('#filterbar > #orders-filter-form > div:last-child > div:nth-child(3) > div:nth-child(4) input').val('Synchronization');
    }
  });

  // Time Picker Initialization
  if ($('html').attr('lang')) {
    let lang = $('html').attr('lang');
    console.log(lang)

    if (lang == "es") {      
      $('.datepicker').datepicker({

        // weekdaysShort: ['Do', 'Lu', 'Ma', 'Mie', 'Jue', 'Vie', 'Sa'],
        showMonthsShort: true,
        min: true,
        closeOnSelect: false,
        rtl: true,
        close: 'Cancelar',
        clear: 'Borrar',

        monthsFull: ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"],
        monthsShort: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sept", "Oct", "Nov", "Dic"],
        weekdaysFull: ["Domingo","Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"],
        weekdaysShort: ["Dom","Lun", "Mar", "Mie", "Jue", "Vie", "Sab"],
        weekdaysAbbrev: ["D","L", "M", "M", "J", "V", "S"],
        today: 'Hoy',
        labelMonthNext: 'Siguiente mes',
        labelMonthPrev: 'Mes anterior',
        labelMonthSelect: 'Selecciona un mes',
        labelYearSelect: 'Selecciona un año'

      });
      
    }
    else{

      $('.datepicker').datepicker({
        // weekdaysShort: ['Do', 'Lu', 'Ma', 'Mie', 'Jue', 'Vie', 'Sa'],
        showMonthsShort: true,
        min: true,
        closeOnSelect: false,
        rtl: true,
        close: 'Cancel',
        clear: 'Clear',

        monthsFull: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
        monthsShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"],
        weekdaysFull: ["Sunday","Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
        weekdaysShort: ["Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
        weekdaysAbbrev: ["S","M", "Tu", "W", "Th", "F", "Sat"],
        today: 'Today',
        labelMonthNext: 'Next Month',
        labelMonthPrev: 'Before Month',
        labelMonthSelect: 'Choose Month',
        labelYearSelect: 'Choose Year'

      });
    }
  }

  
  // $('.datepicker .fa-calendar').click(function (){debugger
  //   let lang = $('html').attr('lang');
  //   if (lang == "es") { 
  //   $('.picker--opened .picker__title-display').text('Seleccione fecha');
  //   }
  // })


  // $('.timepicker').pickatime({
  //   twelvehour: true
  // });

  // $( "#order_form" ).submit(function( event ) {
  //   event.preventDefault();
  //   var dat_che = check_data();
  //   console.log(dat_che);
  //   if (dat_che == false) {
  //     $("#order_form").unbind('submit').submit();
  //   }
  // });

  // $(function() {
  //   $.ajax( {
  //     delay: 500,
  //     type: 'GET',
  //     url: '/users?role=2',
  //     dataType: "json",
  //     success: function(response){
  //       var subsidiary_array = response;
  //       var subsidiary_data = {};
  //       for (var i = 0; i < subsidiary_array.length; i++) {
  //         subsidiary_data[subsidiary_array[i].first_name+" "+subsidiary_array[i].last_name] = subsidiary_array[i];
  //       }
  //       $('input.autocomplete').autocomplete({
  //         data: subsidiary_data,
  //         limit: 5,
  //         onAutocomplete: function (data){
  //           $("#order_customer_id").val(subsidiary_data[data].id);
  //         }
  //       });
  //     }
  //   });
  // })
  //
  // $("#autocomplete-customer").on('keyup', function() {
  //   $("#order_customer_id").val("");
  // });
  //
  // function check_data(){
  //   $customer_id = $("#order_customer_id").val();
  //   if ( $customer_id == "" || $customer_id == "0") {
  //      swal({
  //       title: 'Este Cliente no existe!',
  //       text: 'para agregarlo ingresar el correo electronico',
  //       input: 'email',
  //       inputAttributes: {
  //         autocapitalize: 'off'
  //       },
  //       showCancelButton: true,
  //       confirmButtonText: 'Agregar',
  //       showLoaderOnConfirm: true,
  //       preConfirm: function(value) {
  //        return new Promise(function(resolve) {
  //          $.ajax({
  //           url: '/users',
  //           type: 'POST',
  //           data: {slug: "order" , user: { first_name: $("#autocomplete-customer").val(), role: 'customer', email: value}},
  //           dataType: 'json'
  //           })
  //           .done(function(response){
  //             $("#order_customer_id").val(response.id);
  //             swal('Cliente agregado', response.message, response.status);
  //             return resolve(response);
  //           })
  //           .fail(function(){
  //             swal('Oops...', 'Something went wrong with ajax !', 'error');
  //             $(':input[type="submit"]').prop('disabled', false);
  //           });
  //          });
  //        },
  //       allowOutsideClick: () => !swal.isLoading()
  //     }).then((value) => {
  //       $(':input[type="submit"]').prop('disabled', false);
  //       return true;
  //     })
  //   }
  //   else{
  //     return false;
  //   }
  // }

  //*******SET UP TABLE FEATURES**********/
  $orderF = $('#order-table thead tr > th:nth-child(7)').hasClass('order-f');
  if($orderF) {
    $('#order-table').DataTable({
        "aaSorting": [],
        columnDefs: [{
        orderable: false,
        //targets: [ 6, 7]
        }],
        // "fnInitComplete": function () {
        //   var myCustomScrollbar = document.querySelector('#device-table_wrapper .dataTables_scrollBody');
        //   var ps = new PerfectScrollbar(myCustomScrollbar);
        // },
        "scrollX": true,
        //"scrollY": "70vh",
        "order": [[ 5, "desc" ]]
      });
    } else {
      $('#order-table').DataTable({
        "aaSorting": [],
        columnDefs: [{
        orderable: false,
        //targets: [ 6, 7]
        }],
        // "fnInitComplete": function () {
        //   var myCustomScrollbar = document.querySelector('#device-table_wrapper .dataTables_scrollBody');
        //   var ps = new PerfectScrollbar(myCustomScrollbar);
        // },
        "scrollX": true,
      });
    }
    $('#order-table_wrapper').find('label').each(function () {
      $(this).parent().append($(this).children());
    });
    $('#order-table_wrapper .dataTables_filter').find('input').each(function () {
      const $this = $(this);
      $this.attr("placeholder", "Search");
      $this.removeClass('form-control-sm');
    });
    $('#order-table_wrapper .dataTables_length').addClass('d-flex flex-row');
    $('#order-table_wrapper .dataTables_filter').addClass('md-form');
    $('#order-table_wrapper select').removeClass('custom-select custom-select-sm form-control form-control-sm');
    $('#order-table_wrapper select').addClass('mdb-select');
    $('#order-table_wrapper .dataTables_filter').find('label').remove();


    /****************CAROUSEL INITIALIZATION************/
    $('.carousel-inner > div:first-child, .carousel-indicators > li:first-child').addClass('active');

    /** Llamado a la API para validar disponibilidad del tecnico **/
    $('#val_technic_availability').on('click', function(){

      validate_tecnic_dates();
    });

    Date.prototype.addMins = function(m) {
      this.setTime(this.getTime() + (m*60*1000));  // minutos * seg * milisegundos
      return this;
   }

    function validate_tecnic_dates(){

      var protocol = location.protocol;
      var host = location.host;
      var tecnic_id = $("#order_tecnic_id").val();
      var install_time = $('#order_install_time').val();
      var qty_limit = $('#order_time_number').val();
      var unit_time = $('#select-options-order_time_data li.selected span').text().trim();
      var install_date = $('#order_install_date').val();
      var order_id = $("#order_id").val();

      if (install_date.length > 0) {
          install_date = install_date.replace(',', '');
          install_date = install_date.split(" ");


        switch (install_date[1]) {
          case 'Enero':
          case 'January':
            install_date[1] = 01;
            break;
          case 'Febrero':
          case 'February':
            install_date[1] = 02;
            break;
          case 'Marzo':
          case 'March':
            install_date[1] = 03;
            break;
          case 'Abril':
          case 'April':
            install_date[1] = 04;
            break;
          case 'Mayo':
          case 'May':
            install_date[1] = 05;
            break;
          case 'Junio':
          case 'June':
            install_date[1] = 06;
            break;
          case 'Julio':
          case 'July':
            install_date[1] = 07;
            break;
          case 'Agosto':
          case 'August':
            install_date[1] = 08;
            break;
          case 'Septiembre':
          case 'September':
            install_date[1] = 09;
            break;
          case 'Octubre':
          case 'October':
            install_date[1] = 10;
            break;
          case 'Noviembre':
          case 'November':
            install_date[1] = 11;
            break;
          case 'Diciembre':
          case 'December':
            install_date[1] = 12;
            break;
      }

      f_install_date = install_date.join('-');
      //  var f_install_date = new Date(install_date[2],install_date[1],install_date[0]);
    }
      //install time hour validation

      if (install_time.length > 0) {
        var am_pm = install_time.substr(install_time.length - 2)
        var hour = install_time.substr(0,5)
        var PM = am_pm.match('PM') ? true : false
          time = hour.split(':')
          var min = time[1]

          if (PM) {
              var hour = 12 + parseInt(time[0],10)

          } else {
              var hour = time[0]

          }

          install_time = f_install_date + ' ' + hour + ':' + min;
          var t_install_date = install_date.reverse();
          var limit_time = t_install_date.join('-') + ' ' + hour + ':' + min;

      }

      if (unit_time.length > 0){

        if (unit_time == "Horas" || unit_time == "Hours"){
          hour_t_min = qty_limit * 60;
        }else if (unit_time == "Dias" || unit_time == "Days"){
          hour_t_min = qty_limit * 1440;
        }else{
          hour_t_min = qty_limit;
        }

        var fechaI2 = new Date (limit_time);
        fechaI2.addMins(hour_t_min);
        var final_limit_time = fechaI2.toLocaleString().replaceAll('/','-');

      }

      var url = protocol + '//' + host + '/api/v1/tecnic-available/' + tecnic_id + '?install_date=' + f_install_date + '&install_time=' + install_time + '&limit_time=' + final_limit_time + '&order_id=' + order_id

      fetch(url)
      .then (response => response.json())
      .then( data => {
        let orders = data

        $('.tec_agenda').empty();


        $('.qty').text(data.qty)
        if (orders.ordenes.length > 0){

          orders.ordenes.forEach((order, i) => {

            $('.tec_agenda').append("<td>" + order.internal_id + "</td>")
            $('.tec_agenda').append("<td>" + order.hora_inicial + "</td>")
            $('.tec_agenda').append("<td>" + order.hora_fin + "</td>")
            $('.tec_agenda').append("<td>" + order.direccion + "</td>")

            if (order.cruza){

              $('.tec_agenda').append("<td><i style='color:red' ; class='fas fa-exclamation-triangle fa-lg'></i></td>")
            }
            else{
              $('.tec_agenda').append("<td><i style='color:green' ; class='fas fa-check-circle fa-lg'></i></td>")
            }
            $('.tec_agenda').append("<tr> </tr>")


          })
        }

      })
      .catch(error => {
        console.log("Datos Icompletos.");
      })
    };


      // creacion de un metodo  addMins para la clase Date

    /***************CUSTOMER SELECT VALIDATION ON NEW ORDEN FORM**************/

    $("#order_customer_id option:first-child").prop('disabled', true);

    $('.needs-validation .required select').on('change', function(event) {
      if ($('.needs-validation .required select').val() === null) {
        $('.needs-validation .required').find('.invalid-feedback').show();
      }
      else {
        $('.needs-validation .required').find('.invalid-feedback').hide();
      }
    })

});



/************FORM VALIDATION***********/
(function() {
  'use strict';
  window.addEventListener('load', function() {
    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    var forms = document.getElementsByClassName('order_form');
    // Loop over them and prevent submission
    var validation = Array.prototype.filter.call(forms, function(form) {
      form.addEventListener('submit', function(event) {
        if (form.checkValidity() === false && $('.needs-validation .required select').val() !== null) {
          event.preventDefault();
          event.stopPropagation();
          $('.needs-validation .required').find('.invalid-feedback').hide();
        }
        else if ((form.checkValidity() === false && $('.needs-validation .required select').val() === null) || (form.checkValidity() !== false && $('.needs-validation .required select').val() === null)) {
          event.preventDefault();
          event.stopPropagation();
          $('.needs-validation .required').find('.invalid-feedback').show();
          $('.needs-validation .required').find('.select-dropdown').val('').prop('placeholder', 'No option selected');
        }
        else if (form.checkValidity() !== false && $('.needs-validation .required select').val() !== null) {
          $('.needs-validation .required').find('.invalid-feedback').hide();
        }
        form.classList.add('was-validated');
      }, false);
    });
  }, false);
})();

window.addEventListener("load", function(){
  $('#order-table_wrapper .dataTables_scrollHeadInner thead tr > th:nth-child(6)').delay(1000).click();
  $('#order-table_wrapper .dataTables_scrollHeadInner thead tr > th:nth-child(6)').delay(1000).click();

  /*****************MODIFICACIÓN TEXTO A MOSTRAR EN CLIENTE - NUEVA ORDEN*******************/
  var opciones = $("#select-options-order_customer_id li").find('span');
  opciones.each(function() {
    texto = $(this).text();
    posicion = texto.indexOf('-');
    nombre = texto.substring(0, posicion);
    datos = texto.substring(posicion);
    $(this).text(nombre);
    $(this).append('<span class = "hide">' + datos + '</span>');
  })
});
