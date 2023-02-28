//= require users

$(document).ready(function(){

  /**********VALIDATE SIGN UP FORM*****************/
  $('.validate_field input').on("keyup", function(){
    check_data();
  });

  $('#register').hover(function(){
    check_data();
  });

  $('.validate_field input').on("keyup", function(){
    check_data_complete();
  });

  $('#complete').hover(function(){
    check_data_complete();
  });

  function check_data_complete() {
    var corporation_validated = validate_corporation();
    if (corporation_validated) {
      $('#complete').removeClass('not_continue');
    } else {
      $('#complete').addClass('not_continue');
    }
  }

  function check_data(){
    var email_validated = validate_email();
    var password_validated = validate_password();
    var password_confirmation_validated = validate_password_confirmation();
    var corporation_validated = validate_corporation();
    var phonenumber_validated = validate_phonenumber();
    var activity_validated = validate_activity();
    var name_validated = validate_name();
    var lastname_validated = validate_lastname();
    var document_number_validated = validate_document_number();

    if (email_validated && corporation_validated && password_validated
        && password_confirmation_validated
        && name_validated
        && lastname_validated) {
      $('#register').removeClass('not_continue');
    } else {
      $('#register').addClass('not_continue');
    }
  }

  /**********VALIDATE CHANGE PASSWORD ON EDIT ACCOUNT FORM*****************/
  $('#verify_pass input, #verify_pass_confirm input').on("keyup blur", function(){
    check_pwd();
  });

  function check_pwd(){
    var password_validated = validate_password();
    var password_confirmation_validated = validate_password_confirmation();
    var user_password = $('#user_password').val();
    var password_confirmation = $('#user_password_confirmation').val();

    if (password_validated && password_confirmation_validated || user_password == "" && password_confirmation == "") {
      $('.edit_account').removeClass('not_continue');
    } else {
      $('.edit_account').addClass('not_continue');
    }
  }

  function validate_email(){
    if ($('#user_email').length) {
      var email = isEmail($('#user_email').val());
      if ($('#user_email').val().length >= 5 && email) {
        $('#verify_email .invalid-feedback').css("display", "none");
        return true;
      } else {
        $('#verify_email .invalid-feedback').css("display", "block");
        return false;
      }
    } else {
      return false;
    }
  }

  function validate_password(){
    if ($("#user_password").length){
      var nitRegExp = new RegExp('^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{1,70}$');
      var user_password = $('#user_password').val();
      if (nitRegExp.test(user_password) && $('#user_password').val().length >= 8) {
        $('#verify_pass input').addClass("valid");
        $('#verify_pass input').removeClass("invalid");
        $('#verify_pass .invalid-feedback').css("display", "none");
        return true;
      } else {
        $('#verify_pass input').addClass("invalid");
        $('#verify_pass input').removeClass("valid");
        $('#verify_pass .invalid-feedback').css("display", "block");
        return false;
      }
    } else {
      return false;
    }
  }

  function validate_password_confirmation(){
    if ($('#user_password_confirmation').length) {
      var password = $('#user_password').val();
      var password_confirmation = $('#user_password_confirmation').val();
      if (password_confirmation == password) {
        $('#verify_pass_confirm input').addClass("valid");
        $('#verify_pass_confirm input').removeClass("invalid");
        $('#verify_pass_confirm .invalid-feedback').css("display", "none");
        return true;
      } else {
        $('#verify_pass_confirm input').addClass("invalid");
        $('#verify_pass_confirm input').removeClass("valid");
        $('#verify_pass_confirm .invalid-feedback').css("display", "block");
        return false;
      }
    } else {
      return false;
    }
  }

  function validate_corporation(){
    if ($('#autocomplete-corporation').length) {
      if ($('#autocomplete-corporation').val().length >= 3) {
        $('#verify_corporation .invalid-feedback').css("display", "none");
        return true;
      } else {
        $('#verify_corporation .invalid-feedback').css("display", "block");
        return false;
      }
    } else {
      return false;
    }
  }

  function validate_phonenumber(){
    if ($('#autocomplete-phone_number_1').length) {
      if ($('#autocomplete-phone_number_1').val().length >= 7) {
        $('#verify_phone_number_1 .invalid-feedback').css("display", "none");
        return true;
      } else {
        $('#verify_phone_number_1 .invalid-feedback').css("display", "block");
        return false;
      }
    } else {
      return false;
    }
  }

  function validate_activity(){
    if ($('#autocomplete-activity').length) {
      if ($('#autocomplete-activity').val().length >= 3) {
        $('#verify_activity .invalid-feedback').css("display", "none");
        return true;
      } else {
        $('#verify_activity .invalid-feedback').css("display", "block");
        return false;
      }
    } else {
      return false;
    }
  }

  function validate_name(){
    if ($('#autocomplete-name').length) {
      if ($('#autocomplete-name').val().length >= 3) {
        $('#verify_name .invalid-feedback').css("display", "none");
        return true;
      } else {
        $('#verify_name .invalid-feedback').css("display", "block");
        return false;
      }
    } else {
      return false;
    }
  }

  function validate_lastname(){
    if ($('#autocomplete-lastname').length) {
      if ($('#autocomplete-lastname').val().length >= 3) {
        $('#verify_lastname .invalid-feedback').css("display", "none");
        return true;
      } else {
        $('#verify_lastname .invalid-feedback').css("display", "block");
        return false;
      }
    } else {
      return false;
    }
  }

  function validate_document_number(){
    if ($('#autocomplete-document_number').length) {
      if ($('#autocomplete-document_number').val().length >= 8) {
        $('#verify_document_number .invalid-feedback').css("display", "none");
        return true;
      } else {
        $('#verify_document_number .invalid-feedback').css("display", "block");
        return false;
      }
    } else {
      return false;
    }
  }

  function isEmail(email) {
    var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    return regex.test(email);
  }

  $('#email_register').click(function () {
        $('#form_new_email').show();
        $('#email_register').hide();
    });;

  $('#form_new_email').hide();

});
