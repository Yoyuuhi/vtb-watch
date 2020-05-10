$(document).on('turbolinks:load', function() {
  // mylist作成・編集フォームで、vtuber検索結果を表示する関数
  function SearchVtuber(vtuber) {
    let html = `
    <div class="vtuber-search-result">
      <div class="vtuber-search-result--name">
        ${vtuber.name}
      </div>
      <div class="vtuber-search-result--twitter">
        @${vtuber.twitter}
      </div>
      <div class="vtuber-search-result--company">
        ${vtuber.company}
      </div>
      <div class="vtuber-search-result--add" data-vtuber-id="${vtuber.id}" data-vtuber-name="${vtuber.name}" data-vtuber-twitter="${vtuber.twitter}" data-vtuber-company="${vtuber.company}">
        追加
      </div>
    </div>
    `;
    $("#vtuber-search-results").append(html);
  }

  // mylist作成・編集フォームで、vtuber検索結果がないこと表示する関数
  function SearchNoVtuber() {
    let html = `
      <div class="vtuber-search-result">
        vtuberが見つかりません
      </div>
    `;
    $("#vtuber-search-results").append(html);
  }

  // mylist作成・編集フォームで、mylistに追加したvtuberを表示する関数
  function AddVtuber(name, twitter, company, id) {
    let html = `
    <div class="mylist-vtubers">
      <input name="mylist[vtuber_ids][]" type="hidden" value="${id}">
      <div class="mylist-vtubers--name">
        ${name}
      </div>
      <div class="mylist-vtubers--twitter">
        @${twitter}
      </div>
      <div class="mylist-vtubers--company">
        ${company}
      </div>
      <div class="mylist-vtubers--delete" data-vtuber-id="${id}" data-vtuber-name="${name}" data-vtuber-twitter="${twitter}" data-vtuber-company="${company}">
        削除
      </div>
    </div>
    `;
    $("#mylist-vtubers").append(html);
  }

  // mylist作成・編集フォームで、新たに追加したvtuber情報をinputフォームに入力する関数
  function AddVtuberDB(VtuberId) {
    let html = `<input value="${VtuberId}" name="mylist[vtuber_ids][]" type="hidden" id="mylist_vtuber_ids_${VtuberId}" />`;
    $(`#${VtuberId}`).append(html);
  }

  // mylist作成・編集フォームで、キーワード入力終わるとインクリメンタルサーチを行う
  $("#mylist-form__input").on("keyup", function() {
    let input = $("#mylist-form__input").val();

    var vtuber_exist = [];
    $('input:hidden').each(function() {
      var r = $(this).val();
      vtuber_exist.push(r);
    })
    $.ajax({
      type: "GET",
      url: "/vtubers/searches",
      data: { keyword: input },
      dataType: "json"
    })
      .done(function(vtubers) {
        $("#vtuber-search-results").empty();
        if (vtubers.length !== 0) {
          vtubers.forEach(
          function(vtuber) {
            if($.inArray(String(vtuber.id), vtuber_exist) == -1) {
              SearchVtuber(vtuber);
            }
          });
        } else if (input.length == 0) {
          return false;
        } else {
          SearchNoVtuber();
        }
      })
      .fail(function() {
        console.log("失敗です");
      });
  });

  // mylist作成・編集フォームで、検索結果の「追加」ボタンをクリックすると検索結果から削除、登録vtuberに追加する
  $(document).on("click", ".vtuber-search-result--add", function() {
    const vtuberName = $(this).attr("data-vtuber-name");
    const vtuberTwitter = $(this).attr("data-vtuber-twitter");
    const vtuberCompany = $(this).attr("data-vtuber-company");
    const vtuberId = $(this).attr("data-vtuber-id");
    $(this)
      .parent()
      .remove();
    var vtuber_exist = [];
    $('input:hidden').each(function() {
      var r = $(this).val();
      vtuber_exist.push(r);
    })
    if($.inArray(String(vtuberId), vtuber_exist) == -1) {
      AddVtuber(vtuberName, vtuberTwitter, vtuberCompany, vtuberId);
      AddVtuberDB(vtuberId);
    }
  });
  
  // mylist作成・編集フォームで、登録vtuberの「削除」をクリックすると登録vtuberから削除、再検索を行う
  $(document).on("click", ".mylist-vtubers--delete", function() {
    $(this)
      .parent()
      .remove();
      let input = $("#mylist-form__input").val();

    var vtuber_exist = [];
    $('input:hidden').each(function() {
      var r = $(this).val();
      vtuber_exist.push(r);
    })
    $.ajax({
      type: "GET",
      url: "/vtubers/searches",
      data: { keyword: input },
      dataType: "json"
    })
      .done(function(vtubers) {
        $("#vtuber-search-results").empty();
        if (vtubers.length !== 0) {
          vtubers.forEach(
          function(vtuber) {
            if($.inArray(String(vtuber.id), vtuber_exist) == -1) {
              SearchVtuber(vtuber);
            }
          });
        } else if (input.length == 0) {
          return false;
        } else {
          SearchNoVtuber();
        }
      })
      .fail(function() {
        console.log("失敗です");
      });
  });

  // mylist作成・編集フォームで、hoverしている検索結果を暗くする
  $(".leftbar--section").hover(function() {
    $(this ).css('background-color', '#f8f8ff');
    }, function() {
    $(this ).css('background-color', '');
    });
  // mylist作成・編集フォームで、hoverしている登録vtuberを暗くする
  $(".leftbar-detail--section").hover(function() {
    $(this).css('background-color', '#f8f8ff');
    }, function() {
    $(this).css('background-color', '');
    });

  // 「All」ボタンをクリックする時全ての動画を表示する
  $(".sort--all").on("click", function() {
    $(".sort--all").css('border-bottom', '3px solid rgb(120, 120, 120)')
    $(".sort--onair").css('border-bottom', 'none')
    $(".sort--planned").css('border-bottom', 'none')
    $(".video-boxes-all").css('display', '')
    $(".video-boxes-onair").css('display', 'none')
    $(".video-boxes-planned").css('display', 'none')
  });

  // 「ライブ」ボタンをクリックする時ライブ中の動画を表示する
  $(".sort--onair").on("click", function() {
    $(".sort--all").css('border-bottom', 'none')
    $(".sort--onair").css('border-bottom', '3px solid rgb(120, 120, 120)')
    $(".sort--planned").css('border-bottom', 'none')
    $(".video-boxes-all").css('display', 'none')
    $(".video-boxes-onair").css('display', 'flex')
    $(".video-boxes-planned").css('display', 'none')
  });

  // 「公開予定」ボタンをクリックする時公開予定の動画を表示する
  $(".sort--planned").on("click", function() {
    $(".sort--all").css('border-bottom', 'none')
    $(".sort--onair").css('border-bottom', 'none')
    $(".sort--planned").css('border-bottom', '3px solid rgb(120, 120, 120)')
    $(".video-boxes-all").css('display', 'none')
    $(".video-boxes-onair").css('display', 'none')
    $(".video-boxes-planned").css('display', 'flex')
  });

  // mylist#index, 各mylistをhoverする時編集・削除画面を表示する
  $(".detail--box__top").hover(function() {
    $(".detail--box__top__right-menu", this ).css('display', 'inline');
    }, function() {
    $(".detail--box__top__right-menu", this ).css('display', 'none');
    $(".detail--box__top-confirm", this).css('display', 'none');
    });
  
  // mylist#index, 削除ボタンをクリックした時削除確認画面を表示する
  $(".video-box").on("click", ".detail--box__top__right-menu--delete", function() {
    parent = $(this).parent();
    $(".detail--box__top-confirm", parent).css('display', 'inline');
    });

  // mylist#index, 削除確認画面の「いいえ」ボタンをクリックした時確認画面を非表示する
  $(".video-box").on("click", ".detail--box__top-confirm__no", function() {
    $(".detail--box__top-confirm").css('display', 'none');
    });

  // mylist#showのAll画面の横バー
  $(".video-days").on("click", ".video-days-title", function() {
    parent = $(this).parent();
    if ($(".video-days-contents", parent).css('display') == "flex") {
      $(".video-days-contents", parent).css("display", "none");
      $(".video-days-icon-up", parent).css("display", "flex");
      $(".video-days-icon-down", parent).css("display", "none");
    } else {
      $(".video-days-contents", parent).css("display", "flex");
      $(".video-days-icon-up", parent).css("display", "none");
      $(".video-days-icon-down", parent).css("display", "flex");
    }
  })
});