$(document).on('turbolinks:load', function() {
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

  $(".add-to--form__header__icon").on("click", function(e) {
    $(".add-to").css('visibility', 'hidden');
  })

  $(".add-to-mylist").on("click", function(e) {
    $(".add-to").css('visibility', 'visible');
    if($('.add-to--form__footer').css('display') == 'none') {
      $(".add-to--form__newmylist").css('display', 'none');
      $(".add-to--form__footer").css('display', 'flex');
    }
  })

  $(".add-to--form__footer").on("click", function(e) {
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