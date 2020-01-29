require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'net/smtp'

configure do
  enable :sessions
end

helpers do
  def username
      session[:identity] ? session[:identity] : 'Привіт незнайомець'     

end
end


before '/secure/*' do
  
  
  unless session[:identity]
      session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in with password ' + request.path
    halt erb(:login_form)
end
end

get '/' do
   halt erb (:table)
   # erb :table1
   # erb 'Can you handle a <a href="/secure/place">secret</a>?'
  
end
get '/visit' do
 
  erb :visit
end

post '/visit' do

 if params[:user_name]==''
    @user_name = session[:identity]
    
  else
    @user_name = params[:user_name]
  end
  
  @phone = params[:phone_number]
  @date = params[:date]
  @barber = params[:barber]
  @color= params[:color]
  session[:barber] = params[:barber]
  if params[:user_name] == ''
  @error=  'Введіть як вас звати або зареєструйтесь'
  return erb :visit
  end
  if params[:phone_number] == ''
  @error=  'Введіть будь ласка контактний телефон'
  return erb :visit
  end

  info = "#{@user_name} #{@phone} #{@date} #{@barber} #{@color}\n"
  f = File.open '.\public\visit.txt','a'
  f.write info
  f.close

  erb :visit
  erb "<center><h3><b>Шановний <%=@user_name%>!!!</font></b></h4> <h4>Ви записані до <%=@barber%></h4> <h4>Ми передвзонимо Вам на телефон: <%=@phone%></h4>  <h4><%=@date%>За декілька годин до <%=@date%> !!</h4></center>"
end


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


post '/' do
  
  end

post '/login/attempt' do
  session[:identity] = params['username'] if  params['password'] == ''
  @where_user_came_from = session[:previous_url] || '/'
  redirect to @where_user_came_from
erb "<div class='alert alert-message'>Wrong password</div>"
end


get '/logout' do
  if session.delete(:identity) !=nil
  erb "<div class='alert alert-danger'>Вихід користувача<%=@user_name%> успішний! </div> "

else
  redirect to '/'
end
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end
