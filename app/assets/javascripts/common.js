$(function() {
  $(document).on("click", ".headbar-icon", function() {
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

  $(document).on("click", "#vtuber-search, #vtuber-search-detail", function() {
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