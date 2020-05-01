$(document).on('turbolinks:load', function() {
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

  function SearchNoVtuber() {
    let html = `
      <div class="vtuber-search-result">
        vtuberが見つかりません
      </div>
    `;
    $("#vtuber-search-results").append(html);
  }

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

  function AddVtuberDB(VtuberId) {
    let html = `<input value="${VtuberId}" name="mylist[vtuber_ids][]" type="hidden" id="mylist_vtuber_ids_${VtuberId}" />`;
    $(`#${VtuberId}`).append(html);
  }

  $("#mylist-form__input").on("keyup", function() {
    let input = $("#mylist-form__input").val();
    $.ajax({
      type: "GET",
      url: "/vtubers",
      data: { keyword: input },
      dataType: "json"
    })
      .done(function(vtubers) {
        $("#vtuber-search-results").empty();

        if (vtubers.length !== 0) {
          vtubers.forEach(function(vtuber) {
            SearchVtuber(vtuber);
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

  $(document).on("click", ".vtuber-search-result--add", function() {
    const vtuberName = $(this).attr("data-vtuber-name");
    const vtuberTwitter = $(this).attr("data-vtuber-twitter");
    const vtuberCompany = $(this).attr("data-vtuber-company");
    const vtuberId = $(this).attr("data-vtuber-id");
    $(this)
      .parent()
      .remove();
    AddVtuber(vtuberName, vtuberTwitter, vtuberCompany, vtuberId);
    AddVtuberDB(vtuberId);
  });
  
  $(document).on("click", ".mylist-vtubers--delete", function() {
    $(this)
      .parent()
      .remove();
  });

  $(".leftbar--section").hover(function() {
    $(this ).css('background-color', '#f8f8ff');
    }, function() {
    $(this ).css('background-color', '');
    });

  $(".leftbar-detail--section").hover(function() {
    $(this).css('background-color', '#f8f8ff');
    }, function() {
    $(this).css('background-color', '');
    });


  $("input[type=checkbox]").change(function() {
    $('.edit_vtuber').submit()
  })

  $(".sort--all").on("click", function() {
    $(".sort--all").css('border-bottom', '3px solid rgb(120, 120, 120)')
    $(".sort--onair").css('border-bottom', 'none')
    $(".sort--planned").css('border-bottom', 'none')
    $(".video-boxes-all").css('display', 'flex')
    $(".video-boxes-onair").css('display', 'none')
    $(".video-boxes-planned").css('display', 'none')
    $(".pagination-all").css('display', 'flex')
    $(".pagination-onair").css('display', 'none')
    $(".pagination-planned").css('display', 'none')
  });

  $(".sort--onair").on("click", function() {
    $(".sort--all").css('border-bottom', 'none')
    $(".sort--onair").css('border-bottom', '3px solid rgb(120, 120, 120)')
    $(".sort--planned").css('border-bottom', 'none')
    $(".video-boxes-all").css('display', 'none')
    $(".video-boxes-onair").css('display', 'flex')
    $(".video-boxes-planned").css('display', 'none')
    $(".pagination-all").css('display', 'none')
    $(".pagination-onair").css('display', 'flex')
    $(".pagination-planned").css('display', 'none')
  });

  $(".sort--planned").on("click", function() {
    $(".sort--all").css('border-bottom', 'none')
    $(".sort--onair").css('border-bottom', 'none')
    $(".sort--planned").css('border-bottom', '3px solid rgb(120, 120, 120)')
    $(".video-boxes-all").css('display', 'none')
    $(".video-boxes-onair").css('display', 'none')
    $(".video-boxes-planned").css('display', 'flex')
    $(".pagination-all").css('display', 'none')
    $(".pagination-onair").css('display', 'none')
    $(".pagination-planned").css('display', 'flex')
  });

  $(".detail--box__top").hover(function() {
    $(".detail--box__top__right-menu", this ).css('display', 'inline');
    }, function() {
    $(".detail--box__top__right-menu", this ).css('display', 'none');
    });
});