def isValidPrison(prisonName)
file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close


	db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)
	result=db.query "select * from Prison where Name='#{prisonName}'"
	db.close()
	if (result.num_rows==1)
		return true
	else
		return false
	end
end

get '/prison' do
	
	db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
	result=db.query "select * from Prison where Name='#{params['name']}'"
	db.close
	info=result.fetch_hash
	name=info["Name"]
	state=info["state"]
	city=info["city"]
	region=info["region"]
	warden=info["Warden"]
	numGuards=info["No_of_Guards"]
	prisonersTable=createPrisonersTable(params['name'])
	return "<!DOCTYPE html>
	<html> 
		<head>
			<body background = \"http://www.eji.org/files/Hands%20thru%20bars.jpg\" alt=\"Pulpit rock\" width=\"1920\" height=\"955\">
			<title>Prison: #{name}</title>
		</head>
		<body>
		<center>
			<table>
			<tr><td><h1 style='margin-top: 3px; margin-bottom: 2px'>#{name}</h1></td></tr>
			</table>		
						
		</center>
		<center>
			<h4 style='margin-top: 3px; margin-bottom: 4px'>#{region} #{city}, #{state}</h4>
		</center>
		<center>
			<h5 style='margin-top: 3px; margin-bottom: 2px'><u>Warden:</u> #{warden} &nbsp; &nbsp; <u>Number of Guards:</u> #{numGuards}</h5>
		</center>
		<br /><br />
	#{prisonersTable}#{getBackButton('welcome','get','')}
		</body>
	</html>"
end


def createPrisonersTable(prisonName)
	html="<table>
		<tr><td><h2>Members of your family in prison</h2></td></tr></table>"
	db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
	results= db.query "Select e.Name, e.Emp_ID from Employee e where e.Prison='#{prisonName}' and e.Family='#{$user['Family']}'"
	#debugging
	html<<"<table><tr><td><h4><u>Name</u></h4></td></tr>"
	results.each_hash do |prisoner|
		name=prisoner['Name']
		id=prisoner['Emp_ID']
		html << "<tr><td width=175px>#{name}</td>"
		if (isHead?())
			html << "<td><form action='/breakOut' method='Post'>
				<input type='hidden' name='pname' value=#{prisonName}>
				<input type='hidden' name='empID' value=#{id}></td>
				<td><input type='submit' value='Break him out!'></td>
				</form></td>"
		end
		html<<"</tr>"
	end
	html<<"</table>"
	db.close
	return html
end	

post '/breakOut' do
	random=rand(3)
	db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
	breakOutQuery="call breakoutAttempt(#{$user['Emp_ID']},#{db.escape_string(params['empID'])},#{random})"
	puts "breakoutquery= #{breakOutQuery}"
	results= db.query(breakOutQuery)
	if (results!=nil) 
		newPrison = results.fetch_row()[0]
	end
	db.close()
	breakOutResult(random,params['pname'],newPrison)
		#"<html><body><p>'breakoutSuccess!'<br /> #{getBackButton("prison?name=#{params['pname']}",'get','')}"
	#elsif(random==1)
	#	redirect '/breakoutFail'
	#elsif(random==2)
#		redirect "/breakoutFail?newPrison=#{newPrison}"
	#end
	
end

def breakOutResult(random,prisonName,newPrisoner)
	extraMessage=""
	
	if (random==0)
		message="Breakout Success!"
	else
		message="Breakout Failed, My Bro."
		if (newPrisoner!=nil)
			db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
			prisonerName= db.query "Select Name from Employee where Emp_ID='#{newPrisoner}'"
			name=prisonerName.fetch_row()[0]
			extraMessage="#{name} got caught in the breakout, and is now in prison."
			db.close
		end
	end
	
	return "
	<html>
		<head>
		<body background=\"http://1.bp.blogspot.com/-sq1CzeeeL_w/Tc2ZANL6D5I/AAAAAAAABXw/hhherQPfpQw/s1600/Annex%252520-%252520Keaton%252C%252520Buster%252520%2528Convict%25252013%2529_01.jpg\"alt=\"Pulpit rock\" width=\"1920\" height=\"955\">
		</head>
		<body>
		<p style=\"text-align: center;\"><strong style=\"font-size: 700%;\">#{message}<br /> #{extraMessage}</strong></p>
		<form action='/back' method='post' target='_top' style=''>
			<input type='hidden' name='addr' value='prison?name=#{prisonName}'>
			<input type='submit' value='Back'></form>
		</body>
	</html>"
end

post '/back' do
	
	redirect "#{params['addr']}"
end
