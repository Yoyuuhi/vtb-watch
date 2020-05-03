$(document).on('turbolinks:load', function() {
  // vtuber#showのようなtweetを表示する場合とそれ以外の場合の動画ブロック幅制御
  if ($(".tweet").length != 0) {
    $(".video-boxes-all").css('width', 'calc(100% - 200px)');
    $(".video-boxes-onair").css('width', 'calc(100% - 200px)');
    $(".video-boxes-planned").css('width', 'calc(100% - 200px)');
  } else {
    $(".video-boxes-all").css('width', '100%');
    $(".video-boxes-onair").css('width', '100%');
    $(".video-boxes-planned").css('width', '100%');
  }
  
  // ヘッダー左の矢印をクリックするとメニューの詳細画面を表示する
  $(".headbar-icon").on("click", function() {
    $(".search").css('visibility', 'hidden');
    if ($(".leftbar-detail").is(":hidden")) {
      $(".leftbar").hide();
      $(".headbar--menu_icon-right").hide();
      $(".leftbar-detail").show();
      $(".headbar--menu_icon-left").show();
      $(".headbar--menu_icon-left").css('display', 'flex');
      $(".detail").css('margin-left', '250px');
    } else {
      $(".leftbar-detail").hide();
      $(".leftbar").show();
      $(".headbar--menu_icon-right").show();
      $(".headbar--menu_icon-left").hide();
      $(".detail").css('margin-left', '80px');
    }
  });

  // 左側のメニューにある検索ボタンをクリックすると検索画面を表示する
  $("#vtuber-search, #vtuber-search-detail").on("click", function() {
    if ($(".leftbar-detail").is(":hidden")) {
      $(".search").css('left', '80px');
      $("#search--form--result").empty();
      $("#search--form--input").val('');
      $(".search").css('visibility', 'visible');
    } else {
      $(".search").css('left', '200px');
      $("#search--form--result").empty();
      $("#search--form--input").val('');
      $(".search").css('visibility', 'visible');
    }
  });
})