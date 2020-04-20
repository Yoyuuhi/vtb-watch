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
    console.log($(`#${VtuberId}`))
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

  $(document).on("mouseover", ".detail--box__top", function() {
    id = $(this).attr("data-mylist-id")
    detailCover(id);
  })

  $(".detail--box__top").hover(function() {
    $(".mylist-cover", this ).css('visibility', 'visible');
    }, function() {
    $(".mylist-cover", this ).css('visibility', 'hidden');
    });
});