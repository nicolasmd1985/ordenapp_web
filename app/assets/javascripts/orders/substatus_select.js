$(document).ready(function () {
  'use strict';

  init_value();

  $("#status_id").change(function(){
    var value = $("#status_id").val();
    var lang = document.documentElement.lang;
    switch (value) {
      case "506":
        status_506(lang);
        break;
      case "507":
        status_507(lang);
        break;
      case "508":
        status_508(lang);
        break;
      default:
        $("#substatus_id").empty();
    }
  });

  function status_506(lang){
    var protocol = location.protocol;
    var host = location.host;
    var url = protocol + '//' + host + '/api/v1/substatus/pending';

    fetch(url)
    .then(res => res.json())
    .then(data => {
      $("#substatus_id").empty();
      data.forEach((substatus, i) => {
        var status_description = (lang == "es") ? substatus.description : substatus.description_en;
        if ($("#current_substatus").val() == substatus.id) {
          $("#substatus_id").append('<option value="' + substatus.id + '" selected>' + status_description + '</option>');
        } else {
          $("#substatus_id").append('<option value="' + substatus.id + '">' + status_description + '</option>');
        }
      });

    })
    .catch(error => {
      console.log("Ha ocurrido un error.");
    })
  }

  function status_507(lang){
    var protocol = location.protocol;
    var host = location.host;
    var url = protocol + '//' + host + '/api/v1/substatus/receivable';

    fetch(url)
    .then(res => res.json())
    .then(data => {
      $("#substatus_id").empty();
      data.forEach((substatus, i) => {
        var status_description = (lang == "es") ? substatus.description : substatus.description_en;
        if ($("#current_substatus").val() == substatus.id) {
          $("#substatus_id").append('<option value="' + substatus.id + '" selected>' + status_description + '</option>');
        } else {
          $("#substatus_id").append('<option value="' + substatus.id + '">' + status_description + '</option>');
        }
      });

    })
    .catch(error => {
      console.log("Ha ocurrido un error.");
    })
  }

  function status_508(lang){
    var protocol = location.protocol;
    var host = location.host;
    var url = protocol + '//' + host + '/api/v1/substatus/service';

    fetch(url)
    .then(res => res.json())
    .then(data => {
      $("#substatus_id").empty();
      data.forEach((substatus, i) => {
        var status_description = (lang == "es") ? substatus.description : substatus.description_en;
        if ($("#current_substatus").val() == substatus.id) {
          $("#substatus_id").append('<option value="' + substatus.id + '" selected>' + status_description + '</option>');
        } else {
          $("#substatus_id").append('<option value="' + substatus.id + '">' + status_description + '</option>');
        }
      });

    })
    .catch(error => {
      console.log("Ha ocurrido un error.");
    })
  }

  function init_value(){
    var value = $("#status_id").val();
    var lang = document.documentElement.lang;
    switch (value) {
      case "506":
        status_506(lang);
        break;
      case "507":
        status_507(lang);
        break;
      case "508":
        status_508(lang);
        break;
    }
  }

})
