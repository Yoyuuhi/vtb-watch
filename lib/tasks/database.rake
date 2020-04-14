namespace :database do
  desc "videosをメインとしたデータベース更新"

  # .envファイルを作って環境変数を定義する必要がある
  key = ENV["YOUTUBE_API_KEY"] 
  
  url_temp = "https://www.googleapis.com/youtube/v3"
  task :update => :environment do
    # videoテーブルをクリアする
    Video.all.each do |video|
      video.delete
    end

    # Vtuberテーブル関連
    Vtuber.all.each do |vtuber|
      kind = "channels"
      # チャンネルアイコン情報の取得
      part = "snippet"
      url = URI.parse("#{url_temp}/#{kind}?part=#{part}&id=#{vtuber.channel}&key=#{key}")
      # APIを叩く
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      req = Net::HTTP::Get.new(url)
      res = https.request(req)
      hash = JSON.parse(res.body)
      
      # アイコンのリンク先を保存
      vtuber.icon = hash['items'][0]['snippet']['thumbnails']['medium']['url']
      # チャンネルバナー情報の取得
      part = "brandingSettings"
      url = URI.parse("#{url_temp}/#{kind}?part=#{part}&id=#{vtuber.channel}&key=#{key}")
      # APIを叩く
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      req = Net::HTTP::Get.new(url)
      res = https.request(req)
      hash = JSON.parse(res.body)
      
      # バナーのリンク先を保存
      vtuber.banner = hash['items'][0]['brandingSettings']['image']['bannerImageUrl']

      # チャンネル最新動画情報の取得
      kind = "search"
      part = "snippet"
      maxResults = "10"
      order = "date"
      url = URI.parse("#{url_temp}/#{kind}?part=#{part}&channelId=#{vtuber.channel}&key=#{key}&maxResults=#{maxResults}&order=#{order}")
      # APIを叩く
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      req = Net::HTTP::Get.new(url)
      res = https.request(req)
      hash = JSON.parse(res.body)
      
      # チャンネル名を保存
      vtuber.channelTitle = hash['items'][0]['snippet']['channelTitle']
      vtuber.save
      
      items = hash['items']
      items.each do |item|
        video = Video.new
        video.videoId = item['id']['videoId']
        video.name = item['snippet']['title']
        video.publishedAt = item['snippet']['publishedAt']
        video.vtuber_id = vtuber.id.to_s
        video.save
      end
    end


  
    # 生放送情報の取得
    kind = "videos"
    part = "liveStreamingDetails"
    Video.all.each do |video|
      url = URI.parse("#{url_temp}/#{kind}?part=#{part}&id=#{video.videoId}&key=#{key}")
      # APIを叩く
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      req = Net::HTTP::Get.new(url)
      res = https.request(req)
      hash = JSON.parse(res.body)

      # 生放送時間情報取得
      unless hash['items'][0]['liveStreamingDetails'] == nil
        video.actualStartTime = hash['items'][0]['liveStreamingDetails']['actualStartTime']
        video.actualEndTime = hash['items'][0]['liveStreamingDetails']['actualEndTime']
        video.scheduledStartTime = hash['items'][0]['liveStreamingDetails']['scheduledStartTime']
      end
      video.save
    end
    puts successed!
  end
end