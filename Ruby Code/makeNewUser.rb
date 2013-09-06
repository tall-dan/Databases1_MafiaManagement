def makeNewUser(uname,pword,name,dob,addr,fam,prison)

  file = File.new("/var/www/secret","r")
  dbuser = file.gets.chomp
  dbpass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close
  db= Mysql.new('127.0.0.1', dbuser, dbpass, 'MafiaTracker', 3306)
  sanitizedUname = db.escape_string(uname).strip()
  sanitizedPword = db.escape_string(pword)
  sanitizedName = db.escape_string(name)
  sanitizedDob = db.escape_string(dob)
  sanitizedAddr = db.escape_string(addr)
  
  sanitizedPrison = db.escape_string(prison) 
  query= "Call register('#{sanitizedName}','#{sanitizedDob}','#{sanitizedAddr}','#{fam}','#{sanitizedPrison}',
                                  '#{sanitizedPword}','#{sanitizedUname}','#{encrypt}')"
	puts query
  result= db.query(query)
  error = result.fetch_row()[0]
  puts "Error is #{error}" 
  if error == '0' then
     return newUserSuccess()
  elsif error == '1'
     return noFamily()
  elsif error == '2'
     return noPrison()
  elsif error == '3'
     return noPassword()
  elsif error == '4'
     return noUser()
  elsif error == '5'
     return userAlreadyExists()
  elsif error=='6'
	 return noUserName()
  end
end

def newUserSuccess()
  redirect '/welcome'
end	


def noUserName()
	  "<html><p>User name left blank</p> #{getBackButton("welcome","get","")}</html>"
end

def newUserFail()
  "<html><p>User not created!</p>#{getBackButton("welcome","get","")}</html>"
end

def noFamily()
  "<html><p>Family does not exist</p>#{getBackButton("welcome","get","")}</html>"
end

def noPrison()
  "<html><p>Prison does not exist</p>#{getBackButton("welcome","get","")}</html>"
end

def noPassword()
  "<html><p>Password cannot be empty</p>#{getBackButton("welcome","get","")}</html>"
end

def noUser()
  "<html><p>User cannot be empty</p>#{getBackButton("welcome","get","")}</html>"
end

def userAlreadyExists()
  "<html><p>Username already exists</p>#{getBackButton("welcome","get","")}</html>"
end
