$(document).on('turbolinks:load', function() {
   // vtuber#show, mylistに追加するフォーム, 「新しいmylistを作成」をクリックするとフォームを表示する
   $(".add-to--form__footer").on("click", function(e) {
    $(".add-to--form__newmylist").css('display', 'block');
    $(".add-to--form__footer").css('display', 'none');
    $("#mylist_name").focus();
  })

  // vtuber#show, mylistに追加するフォーム, チェックボックス情報変更する度にsubmit
  $("input[type=checkbox]").change(function() {
    $('.edit_vtuber').submit()
  })

    // vtuber#show, 対応ボタンをクリックするとmylistに追加するフォームを表示する
    $(".add-to-mylist").on("click", function(e) {
      $(".add-to").css('visibility', 'visible');
      if($('.add-to--form__footer').css('display') == 'none') {
        $(".add-to--form__newmylist").css('display', 'none');
        $(".add-to--form__footer").css('display', 'flex');
      }
    })

  // vtuber#show,vtuber#show, mylistに追加するフォーム, 新しいmylistに追加する場合に非同期通信を行う
  $(".new_mylist").on("submit", function(e) {
    e.preventDefault();
    var formData = new FormData(this);
    var url = $(this).attr('action')
    $.ajax({
      url: url,
      type: "POST",
      data: formData,
      dataType: 'text',
      processData: false,
      contentType: false
    })
    .done(function() {
      document.location.reload()
    })
    .fail(function(){
      alert("新しいmylist作成失敗、mylist名を確認してください。\n（mylist名は空や重複にしてはいけません）");
      $('form')[0].reset();
      $('.add-to--form__newmylist__btn').prop('disabled', false);
    });
  })

  // vtuber#show, mylistに追加するフォーム, バツをクリックするとフォームを非表示する
  $(".add-to--form__header__icon").on("click", function(e) {
    $(".add-to").css('visibility', 'hidden');
  })

  // vtuber#show, mylistに追加するフォーム, フォーム以外の部分をクリックするとフォームを非表示する
  $(".add-to").click(function(event) {
    if(!$(event.target).closest('.add-to--form').length) {
      if($('.add-to').css('visibility') == 'visible') {
        $(".add-to").css('visibility', 'hidden');
      }
    }
  });

  // vtuber#sindex画面の横バー
  $(".vtuber-index").on("click", ".vtuber-index--title", function() {
    parent = $(this).parent();
    if ($(".vtuber-boxes", parent).css('display') == "flex") {
      $(".vtuber-boxes", parent).css("display", "none");
      $(".vtuber-index-icon-up", parent).css("display", "flex");
      $(".vtuber-index-icon-down", parent).css("display", "none");
    } else {
      $(".vtuber-boxes", parent).css("display", "flex");
      $(".vtuber-index-icon-up", parent).css("display", "none");
      $(".vtuber-index-icon-down", parent).css("display", "flex");
    }
  })
});