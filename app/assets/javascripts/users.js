function changeCity() {

  let input = ($('#autocompleteCityInput').val()).split(',');
  if (input.length > 1) {
    let keysCity = ($('#autocompleteCityInput').val()).split(',');
    keysCity.pop();
    keysCity = keysCity.join(",");
    keysCity = keysCity.trim().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    let keysCountry = (input[input.length-1]).trim().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    $.ajax({
      type: 'GET',
      url: `/citiesautocomplete?placeid=${keysCity}`,
      success: (response) => {
        let place_id_city = response.candidates[0].place_id;
        $("#placeId").val(place_id_city);
        console.log('change', input);
        console.log("CityID",response);
      }
    });
    $.ajax({
      type: 'GET',
      url: `/citiesautocomplete?placeid=country ${keysCountry}`,
      success: (response) => {
        let place_id_country = response.candidates[0].place_id;
        $("#countryId").val(place_id_country);
        console.log('change', input);
        console.log("CountryID",response);
      }
    });
    if ($('#register').length) {
      $('#register').removeClass('not_continue');
    }
    $('#create_action').removeClass('not_continue');
    console.log($('#autocompleteCityInput').val());
    console.log($('#placeId').val());
    console.log($('#countryId').val());
  }
}

$(document).ready(function(){

  // On edit views remove not_continue class
  if ($('#placeId').val() && $('#countryId').val()) {
    $('#create_action').removeClass('not_continue');
  } else {
    $('#autocompleteCityInput').val('');
  }

  //*******CLEAR BUTTON FUNCTION ON FILTERS FORM**********//
  $('#cancel_search').click(function(){
    var lng = document.documentElement.lang;
    $('#search').val('');
    $('#users-filter-form #city').val('');
    if (lng == "es") {
      $('#filterbar > #users-filter-form > div:nth-child(4) > input').val('Ciudad');
    } else {
      $('#filterbar > #users-filter-form > div:nth-child(4) > input').val('City');
    }
  });

  let validator = $("#userForm").validate();
  let data = [""];
  let options = {
    data: data
  }
  let autocompleteField = $('#autocompleteCityInput');
  // let instances = M.Autocomplete.init(autocompleteField, options);
  let instance;
  let keys = "";

  autocompleteField.on('keydown', (e) => {
    if (e.key == "Enter") {
      e.preventDefault();
      //setTimeout(function() {changeCity()},500);
      changeCity();
    }
    let input = autocompleteField.val()+e.key;
    let key = keys.substring(0,input.length);
    if (input != key && e.key != "ArrowLeft" && e.key != "ArrowRight" && e.key != "ArrowUp" && e.key != "ArrowDown" && e.key != "Enter" && e.key != "Backspace") {
      keys = input;
      console.log(keys);
      $('#results').html(input);
      $.ajax({
        type: 'GET',
        url: `/citiesautocomplete?city=${input}`,
        success: (response) => {
          response.predictions.map((prediction, index) => {
            data[index] = prediction.description;
          });
          console.log("keyup",options);
          //autocompleteField.mdbAutocomplete(options);
        }
      });
      $('#create_action').addClass('not_continue');
    }
  });
  autocompleteField.on('change', () => {
    setTimeout(function() {changeCity()},0);
    $('#create_action').addClass('not_continue');
  });

  $('#autocomplete-subsidiary').on('keypress', function() {
    $.ajax( {
      delay: 500,
      type: 'GET',
      url: '/subsidiaries',
      dataType: "json",
      success: function(response){
        var subsidiary_array = response;
        var subsidiary_data = {};
        for (var i = 0; i < subsidiary_array.length; i++) {
          subsidiary_data[subsidiary_array[i].name] = subsidiary_array[i].id;
        }
        //console.log(subsidiary_data);
        $('input.autocomplete').autocomplete({
          data: subsidiary_data,
          limit: 5,
        });
      }
    });
  })

  autocompleteField.mdbAutocomplete(options);

  //*******SET UP TABLE FEATURES**********/
  if ($('#user-table').length) {
    $('#user-table').DataTable({
      // "aaSorting": [],
      // columnDefs: [{
        // orderable: false,
        // targets: 3
        // }],
        // "fnInitComplete": function () {
          //   var myCustomScrollbar = document.querySelector('#user-table_wrapper .dataTables_scrollBody');
          //   var ps = new PerfectScrollbar(myCustomScrollbar);
          // },
          "scrollX": true,
        });
        $('#user-table_wrapper').find('label').each(function () {
          $(this).parent().append($(this).children());
        });
        $('#user-table_wrapper .dataTables_filter').find('input').each(function () {
          const $this = $(this);
          $this.attr("placeholder", "Search");
          $this.removeClass('form-control-sm');
        });
        $('#user-table_wrapper .dataTables_length').addClass('d-flex flex-row');
        $('#user-table_wrapper .dataTables_filter').addClass('md-form');
        $('#user-table_wrapper select').removeClass('custom-select custom-select-sm form-control form-control-sm');
        $('#user-table_wrapper select').addClass('mdb-select');
        $('#user-table_wrapper .dataTables_filter').find('label').remove();
  }

  /************USERS FORM VALIDATION***********/
  (function() {
    'use strict';
    window.addEventListener('load', function() {
      // Fetch all the forms we want to apply custom Bootstrap validation styles to
      var forms = document.getElementsByClassName('userForm');
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

  /*****CLICK TO UPLOAD IMAGE*******/
  $('#userForm .clic-file, #edit_user .clic-file').click(function(){
    $('#user_urlavatar').click();
  });

  /*********PREVIEW SELECTED IMAGE************/
  if ($('#user_urlavatar').length) {
    document.getElementById("user_urlavatar").onchange = function() {
      const fileList = event.target.files;
      // console.log(fileList);
      // console.log(fileList[0].name);
      var reader = new FileReader();
      reader.onload = function (e) {
          // get loaded data and render thumbnail.
          document.getElementById("user-image").src = e.target.result;
      };
      // read the image file as a data URL.
      reader.readAsDataURL(this.files[0]);
      $('.file-name').text(fileList[0].name);
    };
  }
});
