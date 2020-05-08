namespace :database do
  desc "videosをメインとしたデータベース更新"

  # .envファイルを作って環境変数を定義する必要がある
  key = ENV["YOUTUBE_API_KEY"] 
  
  url_temp = "https://www.googleapis.com/youtube/v3"

  def API_request(url)
    # APIを叩く
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    req = Net::HTTP::Get.new(url)
    res = https.request(req)
    hash = JSON.parse(res.body)
    return hash
  end

  # チャンネル情報更新（更新頻度低い）
  task :update_channel => :environment do
    # Vtuberテーブル関連
    Vtuber.all.each do |vtuber|
      kind = "channels"
      # チャンネルアイコン情報の取得
      part = "snippet,brandingSettings"
      fields = "items(snippet(thumbnails(medium(url)),title),brandingSettings(image(bannerImageUrl)))"
      url = URI.parse("#{url_temp}/#{kind}?part=#{part}&fields=#{fields}&id=#{vtuber.channel}&key=#{key}")
      hash = API_request(url)
      
      unless hash == nil
        # アイコンのリンク先を保存
        vtuber.icon = hash['items'][0]['snippet']['thumbnails']['medium']['url']
        # チャンネル名を保存
        vtuber.channelTitle = hash['items'][0]['snippet']['title']
        # バナーのリンク先を保存
        vtuber.banner = hash['items'][0]['brandingSettings']['image']['bannerImageUrl']
        vtuber.save
      end
    end
  end

  # 動画情報更新（更新頻度高い）
  task :update_video => :environment do
    # videoテーブルをクリアする
    # あくまでデータベースの軽量化のため、場合によって無効化可能
    # Video.all.each do |video|
    #   video.delete
    # end

    Vtuber.all.each do |vtuber|
      # チャンネル最新動画情報（放送・アップロード済み）の取得
      kind = "playlistItems"
      part = "snippet"
      fields = "items(snippet(resourceId(videoId),title,publishedAt,thumbnails(medium(url))))"
      maxResults = "1" # 各チャンネル毎回取得する最新動画の数
      order = "date" # 最新の動画を取得する
      url = URI.parse("#{url_temp}/#{kind}?part=#{part}&fields=#{fields}&playlistId=#{vtuber.channel.gsub(/^UC/,'UU')}&key=#{key}&maxResults=#{maxResults}&order=#{order}")
      hash = API_request(url)

      items = hash['items']
      unless hash == nil
        items.each do |item|
          # vtuberのチャンネルに新しいマイリストが作られた場合その情報がsnippetに含まれ、'videoId'がないため保存しようとするとエラーが発生する
          if item['snippet']['resourceId']['videoId'] != nil then
            # videoIdによってcreateとupdateを分ける
            if Video.find_by(videoId: item['snippet']['resourceId']['videoId']) == nil then
              video = Video.new
            else
              video = Video.find_by(videoId: item['snippet']['resourceId']['videoId'])
            end
            video.videoId = item['snippet']['resourceId']['videoId']
            video.name = item['snippet']['title']
            video.publishedAt = item['snippet']['publishedAt']
            video.vtuber_id = vtuber.id.to_s
            video.cover = item['snippet']['thumbnails']['medium']['url']
            video.save
          end
        end
      end

      # チャンネル最新動画情報（生放送予定・中）のvideoId取得
      ## 燃費の悪いsearch:listを捨ててAPIの割り当てを消耗しない方法にしました！（ドヤ）
      ## Googleさん、live_stream情報に関して不親切すぎません？
      url = "https://www.youtube.com/embed/live_stream?channel=#{vtuber.channel}"
      content = Net::HTTP.get_response(URI.parse(url)).entity
      unless content.match(/watch\?.+/) == nil
        match = content.match(/watch\?.+/)[0]
      end
      videoId = match.sub("watch?v=","").sub("\">","")
      if Video.find_by(videoId: videoId) == nil then
        video = Video.new
      else
        video = Video.find_by(videoId: videoId)
      end
      
      unless videoId == nil
        video.videoId = videoId
        video.vtuber_id = vtuber.id.to_s

        # 取得した生放送idを使って名前やカバーなどを取得する
        kind = "videos"
        part = "snippet"
        fields = "items(snippet(title,publishedAt,thumbnails(medium(url))))"
        maxResults = "1"
        url = URI.parse("#{url_temp}/#{kind}?part=#{part}&fields=#{fields}&id=#{videoId}&key=#{key}&maxResults=#{maxResults}")
        hash = API_request(url)
        unless hash == nil
          items = hash['items'][0]
          video.name = items['snippet']['title']
          video.publishedAt = items['snippet']['publishedAt']
          video.cover = items['snippet']['thumbnails']['medium']['url']
          video.save
        end
      end
    end
  end

  task :update_liveSchedule => :environment do
    # 生放送情報の取得
    kind = "videos"
    part = "liveStreamingDetails"
    fields = "items(liveStreamingDetails(actualStartTime,actualEndTime,scheduledStartTime))"
    Video.all.each do |video|
      # 生放送ではない（liveStreamingDetailsがFalse）と生放送終了（actualEndTimeが存在する）場合APIを叩かない
      unless video.liveStreamingDetails != nil || video.actualEndTime != nil
        url = URI.parse("#{url_temp}/#{kind}?part=#{part}&fields=#{fields}&id=#{video.videoId}&key=#{key}")
        hash = API_request(url)
        unless hash == nil
          # 生放送時間情報取得
          unless hash['items'][0]['liveStreamingDetails'] == nil
            video.actualStartTime = hash['items'][0]['liveStreamingDetails']['actualStartTime']
            video.actualEndTime = hash['items'][0]['liveStreamingDetails']['actualEndTime']
            video.scheduledStartTime = hash['items'][0]['liveStreamingDetails']['scheduledStartTime']
          else
            # APIが返してきたliveStreamingDetailsが空の場合データベースでliveStreamingDetails = Falseと記録する
            video.liveStreamingDetails = False
          end
          video.save
        end
      end
    end
  end
end