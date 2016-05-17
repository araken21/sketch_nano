require 'sinatra'
require 'sqlite3'
require 'sinatra/json'
require 'data_uri'
require 'securerandom'
require 'logger'
require 'sinatra/reloader'
require 'json'

logger = Logger.new(STDOUT)

# DBの生成
db = SQLite3::Database.new 'db/post.db'
db.results_as_hash = true

error 400 do
 status 400
 body 'リクエストが不正です'
end

get '/' do
  erb :index
end

get '/dashboard' do
  if params[:adult] == "1"
    posts = db.execute("SELECT * FROM pictures ORDER BY id DESC")
  else
    posts = db.execute("SELECT * FROM pictures WHERE adult is null or adult = 0 ORDER BY id DESC")
  end

  erb :dashboard, {:locals => {:posts => posts}}
end

get '/draw' do
  erb :draw
end

post '/draw' do
  title = params[:title]
  adult_i = params[:adult]

  datauri = params['src']  # UR がデータ　il で範囲が決まるイメージ
  img = URI::Data.new(datauri).data


  # ファイル名をつける
  name = SecureRandom.hex + '.png'

  # 画像を保存
  File.open("./public/uploads/" + name, "wb") do |file|
    file.write img
  end
  # DBに登録する
  time = Time.now.strftime('%Y-%m-%d %H:%M:%S')

  if params[:adult] == "true"
    adult_i = "1"
  else
    adult_i = "0"
  end
  sql = "INSERT INTO pictures (title, src, likes, posted_at,adult) VALUES (:title, :name, :likes, :time, :adult)"
  db.execute(sql,
    "title" => params[:title],
    "name" => name,
    "likes" => 5,
    "time" => time,
    "adult" => adult_i
  )

  # 終わったらダッシュボードに戻る
  redirect '/dashboard'
end

post '/api/like' do
  postid = params[:id].to_i
  unless postid
    error 400
  end

  sql = "SELECT id, likes FROM pictures WHERE id = :id"
  post = db.execute(sql, id: postid)

  if post.length == 1
    post = post[0]
  else
    error 400
  end

  if post["likes"] <= 0
     sql = "DELETE FROM pictures WHERE id = :id"
     db.execute(sql, id: postid)
     JSON.generate({status: 'delete', id: postid})
  else
     sql = "UPDATE pictures SET likes = likes - 1 WHERE id = :id"
     db.execute(sql, id: postid)
     JSON.generate({status: 'update', id: postid, likes: post['likes'] - 1})
  end
end
