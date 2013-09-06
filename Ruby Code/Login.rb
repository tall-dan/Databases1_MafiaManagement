require 'rubygems'
require 'redirect'
require 'sinatra'
require 'mysql'
require 'net/http'
require 'uri'
require 'sinatra/flash'
require 'net/http/post/multipart'
require_relative 'authenticate'
require_relative 'makeNewUser'
require_relative 'register'
require_relative 'welcome'
require_relative 'loginFail'
require_relative 'UnknownError'
require_relative 'projectForm'
require_relative 'updateEmp'
require_relative 'business'
require_relative 'prison'
require_relative 'turfForm'
require_relative 'productForm'
$user="" 



get '/register' do 	
 return getRegisterHtml()
end	
	
post '/authenticate' do
  params.each{|param| p param}#just for debugging
  if (authenticate(params["Username"], params["password"]))
	redirect "/welcome"
  else	
	redirect '/loginFail'
  end	
end

get '/welcome' do
	return getWelcomeHTML()
end

get '/loginFail' do 
	return getFailHTML()
end

post '/createProject' do
	return getProjectForm()
end

post '/checkNewUser' do
  params.each{|param| p param}
  makeNewUser(params["username"],params["password"],params["name"],params["dob"],params["address"],params["family"],params["prison"])
end
    
get '/login' do 
  return getAuthenticateHTML()
end

get '/updateEmp' do
	return updateEmpHTML()
end

get '/UnknownError' do 	
  return getUnknownHTML()
end

post '/businessInfo' do 
	puts "**** params for businessInfo"
	params.each{|param| p param}
	return getBusinessPage(params["busID"])
end

def bossOfFamily()
	if (isHead?())
		db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
		famName=db.query("select * from Family where Head='#{$user['Emp_ID']}'").fetch_hash['Name']
		return famName
	else
		return nil
	end
end 

def isHead?()
	db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
	famTable=db.query "select * from Family where Head='#{$user['Emp_ID']}'"
	if (famTable.num_rows==1)
		return true
	else
		return false
	end
end

def getInfoFromUname(uname)
	db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
	result=db.query "select * from Employee where Username='#{uname}'"
	toRet=result.fetch_hash
	return toRet
end

get '/newTurf' do
	return newTurfForm()
end

def getBackButton(action,method,style)
	puts "backbutton action= #{action}"
	return "<form action='/#{action}' method='#{method}' target='_top' style='#{style}'>
			<input type='submit' value='Back'></form>"
end

def isLegit?(busID)
	db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
	legit=db.query("select Legit from Business where ID=#{busID}").fetch_hash['Legit']	
	db.close()
	return legit=='1'
end