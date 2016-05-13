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

get '/' do
  erb :index
end

get '/dashboard' do
  if params[:adult] == "1"
    posts = db.execute("SELECT * FROM pictures ORDER BY id DESC")
  else
    posts = db.execute("SELECT * FROM pictures WHERE adult is null ORDER BY id DESC")
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
  adult_i = params[:adult]? "1" : "0"
  sql = "INSERT INTO pictures (title, src, posted_at,adult) VALUES ('#{params['title']}', '#{name}', '#{time}', '#{adult_i}')"
  db.execute_batch(sql)

  # 終わったらダッシュボードに戻る
  redirect '/dashboard'
end

post '/api/like' do
  sql = "UPDATE pictures SET likes=likes+1 WHERE(id = '#{params[:id]}')"
  db.execute_batch(sql)
end
