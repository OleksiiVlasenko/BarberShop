#encoding: UTF-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'net/smtp'
require 'sqlite3'
require 'sinatra/activerecord'

set :database,"sqlite3:barber.db"


# ----  Update to ActiveRecord ------

class Client < ActiveRecord::Base


end

class Barber < ActiveRecord::Base


end






# ----  Update to ActiveRecord ------

def get_db
return SQLite3::Database.new '.\public\barber.db'
end

configure do
  enable :sessions

 # @db = get_db
 # @db.execute 'CREATE TABLE IF NOT EXISTS "Users" 
 # ("id"  INTEGER PRIMARY KEY AUTOINCREMENT,"name"  
 # TEXT,"phone" TEXT,"datestamp" TEXT, "barber"  TEXT, "color" TEXT);'

 # @db.execute 'CREATE TABLE IF NOT EXISTS "Barbers" 
 # ("id"  INTEGER PRIMARY KEY AUTOINCREMENT,"name"  
 # TEXT,"type"  TEXT, "workingtime" TEXT);'
end

helpers do
  def username
      session[:identity] ? session[:identity] : 'Привіт незнайомець'     

end
end


before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do

  
erb (:table)
  
end

post '/' do
    @user_name = session[:identity]
    erb (:table)
  end

before do
#код который будет иницилиазирован перед всеми представлениями, каждыйр раз иниц, похож на configure в начале
# db = get_db 
# db.results_as_hash = true
# @barbers = db.execute "SELECT * FROM Barbers"
@barbers = Barber.all
end

get '/visit' do

  erb (:visit)
end

post '/visit' do
if params[:user_name] == ''
  @error=  "<div class='alert alert-danger'>Введіть як вас звати або зареєструйтесь</div>"
  return erb :visit
  elsif params[:user_name].include?("'")
    @error=  "<div class='alert alert-danger'>Охуел?</div>"
  return erb :visit
  end
 if params[:phone_number] == ''
  @error=  "<div class='alert alert-danger'>Введіть будь-ласка контактний телефон</div>"
  return erb :visit
  elsif params[:phone_number].include?("'")
    @error=  "<div class='alert alert-danger'>Охуел?</div>"
  return erb :visit
  end
   if params[:date] == ''
  @error=  "<div class='alert alert-danger'>Введіть будь-ласка виберіть дату</div>"
  return erb :visit
  elsif params[:date].include?("'")
    @error=  "<div class='alert alert-danger'>Охуел?</div>"
  return erb :visit
  end
  Client.create :name=>params[:user_name],:phone=>params[:phone_number],:datestamp=>params[:date],:barber=>params[:barber],:color=>params[:color]
  erb :visit
   erb "<center><h3><b>Шановний <%=params[:user_name]%>!!!</font></b></h4>
    <h4>Ви записані до <%=params[:barber]%></h4>
     <h4>Ми передвзонимо Вам на телефон: <%=params[:phone_number]%></h4>
     <h4>За декілька годин до <%=params[:date]%> !!</h4></center>"
#   @user_name = params[:user_name]
#   @phone = params[:phone_number]
#   @date = params[:date]
#   @barber = params[:barber]
#   @color= params[:color]
#   session[:barber] = params[:barber]
  


 
  
#   @db = get_db
#   @is_date_valid = @db.execute 'SELECT id FROM Users where ? = datestamp',[@date]
#   if @is_date_valid != []
#    @error=  "<div class='alert alert-danger'>Ця дата зайнята</div>"  
#   return erb :visit
# else
#    @db.execute 'insert into Users(name,phone,datestamp,barber,color) values(?,?,?,?,?)', [@user_name,@phone,@date,@barber,@color]  
#   end
#   # @db.execute 'insert into Users(name,phone,datestamp,barber,color) values(?,?,?,?,?)', [@user_name,@phone,@date,@barber,@color]
#   @db.close
  
 
end

get '/show_users' do
  # db = get_db
  # @r =[]
 # @db.results_as_hash = true
 # @results = db.execute 'SELECT * FROM Users order by id desc'
 # @r << ['11','22','33']
  @clients = Client.all

 erb :show_users

 end

# post '/show_users' do

# end



get '/about' do
  erb :about
end

post '/about' do
@your_mail = params[:your_mail]

erb "<h3>Вітаю Вас Ви підписались на нововини від нашої компанії  #{@your_mail} </h3> <center> <a href=""<%=@where_user_came_from %>"">Повернутись</a></center>"



# from = 'a.a.a.vlasenko@gmail.com'
# to = 'a.a.a.vlasenko@gmail.com'
# theme = 'asd'
# text="asd"
# message=""
# message<<"From: ot kogo <#{from}>\n"
# message<<"To: #{to}\n"
# message<<"Subject: #{theme}\n"
# message<<text
# Net::SMTP.new('smtp.gmail.com', 587).start('a.a.a.vlasenko@gmail.com', 'a.a.a.vlasenko', 'A159159a', :login) do |smtp|
# smtp.send_message message, from, to
# end

end




get '/login/form' do
  erb :login_form
end




post '/login/attempt' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from
end



get '/logout' do
  if session.delete(:identity) !=nil
  erb "<div class='alert alert-primary'>Вихід користувача<%=@user_name%> успішний! </div> "

else
  redirect to '/'
end
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end
