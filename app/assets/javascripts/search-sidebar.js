// 左側のメニューにある検索機能
$(document).on('turbolinks:load', function() {
  // 検索結果を表示する関数
  function SearchVtuberSide(vtuber) {
    let html = `
    <a href="/vtubers/${vtuber.id}" class="search--form--result-a">
      <div class="search--form--result">
        <div class="search--form--result--left">
          ${vtuber.name}
        </div>
        <div class="search--form--result--middle">
          @${vtuber.twitter}
        </div>
        <div class="search--form--result--right">
          ${vtuber.company}
        </div>
      </div>
    </a>
    `;
    $("#search--form--result").append(html);
  }

  // 検索結果がないことを表示する関数
  function SearchNoVtuberSide() {
    let html = `
      vtuberが見つかりません
    `;
    $("#search--form--result").append(html);
  }

  // 検索フォームへの入力が終わるとインクリメンタルサーチを行う
  $("#search--form--input").on("keyup", function() {
    let input = $("#search--form--input").val();
    $.ajax({
      type: "GET",
      url: "/vtubers/searches",
      data: { keyword: input },
      dataType: "json"
    })
      .done(function(vtubers) {
        $("#search--form--result").empty();

        if (vtubers.length !== 0) {
          vtubers.forEach(function(vtuber) {
            SearchVtuberSide(vtuber);
          });
        } else if (input.length == 0) {
          return false;
        } else {
          SearchNoVtuberSide();
        }
      })
      .fail(function() {
        console.log("失敗です");
      });
  });

  // 検索画面右上のバツをクリックすると検索画面を非表示する
  $(".search--form--close__icon").on("click", function(e) {
    $(".search").css('visibility', 'hidden');
  })

  // 検索画面以外のbody contentをクリックすると検索画面を非表示する
  $(".search").click(function(event) {
    if(!$(event.target).closest('.search--form').length) {
      if($('.search').css('visibility') == 'visible') {
        $(".search").css('visibility', 'hidden');
      }
    }
  });
})