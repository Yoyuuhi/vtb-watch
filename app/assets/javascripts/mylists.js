$(function() {
  function SearchVtuber(vtuber) {
    let html = `
      <div class="mylist-form__field--right">
        <p class="vtuber__name">${vtuber.name}</p>
        <div class="vtuber__btn--add" data-vtuber-id="${vtuber.id}" data-vtuber-name="${vtuber.name}">追加</div>
      </div>
    `;
    $("#vtuber-search-result").append(html);
  }

  function SearchNoVtuber() {
    let html = `
      <div class="mylist-form__field--right">
        <p class="vtuber__name">vtuberが見つかりません</p>
      </div>
    `;
    $("#vtuber-search-result").append(html);
  }

  function AddVtuber(name, id) {
    let html = `
    <div class="mylist-vtuber clearfix" id="${id}">
      <p class="mylist-vtuber__name">${name}</p>
      <div class="vtuber-search-remove vtuber__btn--remove js-remove-btn" data-vtuber-id="${id}" data-vtuber-name="${name}">削除</div>
    </div>`;
    $(".js-add-vtuber").append(html);
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
        $("#vtuber-search-result").empty();

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

  $(document).on("click", ".vtuber__btn--add", function() {
    const vtuberName = $(this).attr("data-vtuber-name");
    const vtuberId = $(this).attr("data-vtuber-id");
    $(this)
      .parent()
      .remove();
    AddVtuber(vtuberName, vtuberId);
    AddVtuberDB(vtuberId);
  });
  $(document).on("click", ".vtuber-search-remove", function() {
    $(this)
      .parent()
      .remove();
  });

  $(".detail--box__top").hover(function() {
    $(".mylist-cover", this ).css('visibility', 'visible');
    }, function() {
    $(".mylist-cover", this ).css('visibility', 'hidden');
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

  $(document).on("click", ".sort--all", function() {
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

  $(document).on("click", ".sort--onair", function() {
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

  $(document).on("click", ".sort--planned", function() {
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
});