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
      part = "snippet"
      url = URI.parse("#{url_temp}/#{kind}?part=#{part}&id=#{vtuber.channel}&key=#{key}")
      hash = API_request(url)
      
      # アイコンのリンク先を保存
      vtuber.icon = hash['items'][0]['snippet']['thumbnails']['medium']['url']
      # チャンネル名を保存
      vtuber.channelTitle = hash['items'][0]['snippet']['title']
      vtuber.save

      # チャンネルバナー情報の取得
      part = "brandingSettings"
      url = URI.parse("#{url_temp}/#{kind}?part=#{part}&id=#{vtuber.channel}&key=#{key}")
      hash = API_request(url)
      
      # バナーのリンク先を保存
      vtuber.banner = hash['items'][0]['brandingSettings']['image']['bannerImageUrl']

      puts "succeed!"
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
      # チャンネル最新動画情報の取得
      kind = "search"
      part = "snippet"
      maxResults = "1" # 各チャンネル毎回取得する最新動画の数
      order = "date" # 最新の動画を取得する
      url = URI.parse("#{url_temp}/#{kind}?part=#{part}&channelId=#{vtuber.channel}&key=#{key}&maxResults=#{maxResults}&order=#{order}")
      hash = API_request(url)

      items = hash['items']
      items.each do |item|
        # vtuberのチャンネルに新しいマイリストが作られた場合その情報がsnippetに含まれ、'videoId'がないため保存しようとするとエラーが発生する
        if item['id']['videoId'] != nil then
          # videoIdによってcreateとupdateを分ける
          if Video.find_by(videoId: item['id']['videoId']) == nil then
            video = Video.new
          else
            video = Video.find_by(videoId: item['id']['videoId'])
          end
          video.videoId = item['id']['videoId']
          video.name = item['snippet']['title']
          video.publishedAt = item['snippet']['publishedAt']
          video.vtuber_id = vtuber.id.to_s
          video.cover = item['snippet']['thumbnails']['medium']['url']
          video.save
        end
      end
    end

    # 生放送情報の取得
    kind = "videos"
    part = "liveStreamingDetails"
    Video.all.each do |video|
      # 生放送ではない（liveStreamingDetailsがFalse）と生放送終了（actualEndTimeが存在する）場合APIを叩かない
      unless video.liveStreamingDetails == False || video.actualEndTime != nil
        url = URI.parse("#{url_temp}/#{kind}?part=#{part}&id=#{video.videoId}&key=#{key}")
        hash = API_request(url)

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
    puts "succeed!"
  end
end