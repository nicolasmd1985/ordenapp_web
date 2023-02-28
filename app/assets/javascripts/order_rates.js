$(function(){
  if ($('.order_rate_form')) {

    $('input').click(function(){
      check_answers();
    });

    function check_answers(){
      var answers_1 = check_answer_1();
      var answers_2 = check_answer_2();
      var answers_3 = check_answer_3();
      var answers_4 = check_answer_4();
      var answers_5 = check_answer_5();

      if (answers_1 && answers_2 && answers_3 && answers_4 && answers_5) {
        $('#send_data').removeClass('not_continue');
      } else
      {
        $('#send_data').addClass('not_continue');
      }
    }

    function check_answer_1(){
      if ($('input[name="order_rate[answer_1]"]:checked').length > 0) {
        return true
      } else {
        return false
      }
    }

    function check_answer_2(){
      if ($('input[name="order_rate[answer_2]"]:checked').length > 0) {
        return true
      } else {
        return false
      }
    }

    function check_answer_3(){
      if ($('input[name="order_rate[answer_3]"]:checked').length > 0) {
        return true
      } else {
        return false
      }
    }

    function check_answer_4(){
      if ($('input[name="order_rate[answer_4]"]:checked').length > 0) {
        return true
      } else {
        return false
      }
    }

    function check_answer_5(){
      if ($('input[name="order_rate[answer_5]"]:checked').length > 0) {
        return true
      } else {
        return false
      }
    }

  }
});
