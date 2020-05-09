$(document).on('turbolinks:load', function() {
  // 動画playerを表示する関数（YouTube Player API使用）
  function iframe(videoId) {
    let html = `
    <div class="iframe" id="${videoId}">
      <div class="iframe--close">
        <i class="fas fa-times iframe--close__icon"></i>
      </div>
      <div class="iframe--video">
        <div id="player"></div>
      </div>
    </div>
    `;
    $(".wrapper").append(html);
    player = new YT.Player('player', {
      height: '360',
      width: '640',
      videoId: videoId,
      events: {
        'onReady': onPlayerReady,
      }
    });
  }

  // 動画のタイトルやカバーをクリックする時playerを開く
  $(".video-box--video, .video-box--name").on("click", function(){
    videoId = $(this).attr("value");
    iframe(videoId)
  })

  // 動画playerを閉じる関数
  $(document).on("click", ".iframe", function() {
    $(".iframe").remove()
  });
})

