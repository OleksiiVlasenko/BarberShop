require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :sessions
end

helpers do
  def username
      session[:identity] ? session[:identity] : 'Hello stranger'     

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
   halt erb (:table)
   erb :table1
   erb 'Can you handle a <a href="/secure/place">secret</a>?'
  
end

get '/login/form' do
  erb :login_form
end




post '/login/attempt' do
  session[:identity] = params['username'] if  params['password'] == 'nube'
  @where_user_came_from = session[:previous_url] || '/'
  redirect to @where_user_came_from
 erb "<div class='alert alert-message'>Wrong password</div>"

end

get '/logout' do
  if session.delete(:identity) !=nil
  erb "<div class='alert alert-message'>Logged out</div>"
else
  redirect to '/'
end
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end
