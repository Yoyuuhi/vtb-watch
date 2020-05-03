# インクリメンタルサーチ用jbuilder
json.array! @vtubers do |vtuber|
  json.id vtuber.id
  json.name vtuber.name
  json.twitter vtuber.twitter
  json.company vtuber.company.name
end