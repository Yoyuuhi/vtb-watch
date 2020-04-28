$(function() {
  $(".new_mylist").on("submit", function(e) {
    e.preventDefault();
    $(".add-to").css('visibility', 'hidden');
    var formData = new FormData(this);
    var url = $(this).attr('action')
    $.ajax({
      url: url,
      type: "POST",
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false
    })
  })

  $(document).on("click", ".add-to--form__header__icon", function(e) {
    $(".add-to").css('visibility', 'hidden');
  })

  $(document).on("click", ".add-to-mylist", function(e) {
    $(".add-to").css('visibility', 'visible');
    if($('.add-to--form__footer').css('display') == 'none') {
      $(".add-to--form__newmylist").css('display', 'none');
      $(".add-to--form__footer").css('display', 'flex');
    }
  })

  $(document).on("click", ".add-to--form__footer", function(e) {
    $(".add-to--form__newmylist").css('display', 'block');
    $(".add-to--form__footer").css('display', 'none');
  })

  $(".add-to").click(function(event) {
    if(!$(event.target).closest('.add-to--form').length) {
      if($('.add-to').css('visibility') == 'visible') {
        $(".add-to").css('visibility', 'hidden');
      }
    }
  });

  

});