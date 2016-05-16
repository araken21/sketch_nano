require 'sinatra'
require 'sqlite3'
require 'sinatra/json'
require 'data_uri'
require 'securerandom'
require 'logger'

logger = Logger.new(STDOUT)

# DBの生成
db = SQLite3::Database.new 'db/post.db'
db.results_as_hash = true

error do |e|
  status 400
  body e.message
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

  datauri = params['src']
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
  sql = "INSERT INTO pictures (title, src, posted_at,adult) VALUES (:title, :name, :time, :adult)"
  db.execute(sql,
    "title" => params[:title],
    "name" => params[:name],
    "time" => time,
    "adult" => params[:adult]
  )

  # 終わったらダッシュボードに戻る
  redirect '/dashboard'
end

post '/api/like' do
  sql = "SELECT * FROM pictures WHERE(id = :id')"
  post = db.execute(sql,
  "id" => params[:id]
  )

   if post[0]["likes"] <= 0
     sql = "DELETE FROM pictures WHERE(id = :id)"
     db.execute(sql,
     "id" => params[:id]
     )
   else
      sql = "UPDATE pictures SET likes=likes-1 WHERE(id = :id)"
      db.execute(sql,
      "id" => params[:id]
      )
   end
end
