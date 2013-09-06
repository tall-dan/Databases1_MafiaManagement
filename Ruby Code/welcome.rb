def getWelcomeHTML()
	id=$user['Emp_ID']
	name=$user['Name']#might be [:Name]
	family=$user['Family']
	projectTable=createProjectsTable(id)
	joinExistingTable=getJoinExistingTable()
	createProjectButton=createProjectButton()
	familyDiv=getFamilyDiv()
	if (isHead?())
		addEmployeeButton=getEmployeeButton()
	end
	return "   
   <html> 
	<head>
		<title>Welcome</title>
		<body background=\"http://www.whitefauxtaxidermy.com/files/3770662/uploaded/white-resin-wolf-head1.jpg\" alt=\"Pulpit rock\" width=\"1920\" height=\"955\">
	</head>
	<body>
	<center>
		<h1 style='display:inline'>Welcome, #{name}!</h1><h6 style='display:inline'><a href='/updateEmp'>Edit</a></h6> 
	</center>
	<table>
		<tr><td width=1300px>
			<form action='/prisonSearch' method='post'>
					<input type='text' name='prisonName' onfocus=\"this.value=''\"  onblur=\"if (this.value=='') this.value='Find a Prison'\" value='Find a Prison'>
					<input type= 'submit' value='Search'>
					</form>
			</td>
			<td>
			<form action='/businessSearch' method='post'>
					<input type='text' name='businessName' onfocus=\"this.value=''\"  onblur=\"if (this.value=='') this.value='Find a Business'\" value='Find a Business'>
					<input type= 'submit' value='Search'>
					</form>
			</td>
		</tr>
	</table>
	<br />
	<table>
		<tr><td width=800px><h2>Work on a project...</h2></td><td><h2 style='display:inline'>The #{family} family #{addEmployeeButton}</h2></td></tr></h2>
	</table>
	<div style='width: 100%; display: table;'>
        <div style='display: table-row'>
        <div style='width: 800px; display: table-cell;'>  
        <table style='width:80%;'>
            #{projectTable}
			#{createProjectButton}
		</table>		<br /><br />	
			#{joinExistingTable}

		</div>
		#{familyDiv}
		
    </div>
    </div>
	</body>
</html>"
end

def getFamilyDiv()
	if ($user['Family']==nil)
		return "<div style='display: table-cell;'>
				<table><tr><td><form action='/createFamily' method='post'>
					<input type='text' name='famName' onfocus=\"this.value=''\"  onblur=\"if (this.value=='') this.value='Family Name'\" value='Family Name' </input>
					<input type= 'submit' value='Create New Family'></input>
					</form>
				</td></tr></table></div>"
	end
	enemiesTable=createEnemiesTable()
	
	turfTable=createTurfTable()
	theirTurf=createTheirTurfTable()
	toRet="<div style='display: table-cell;'> <!The right side of the welcome page>
			#{getEmployeesTable()}
			<h3>Know Your Enemies</h3>
		    #{enemiesTable}
			<br />
			<br />"
			
	if (!isHead?())
		toRet<<"<table><tr><td><form action='/createFamily' method='post' style='display:inline'>
						<input type='text' name='famName' onfocus=\"this.value=''\"  onblur=\"if (this.value=='') this.value='New Family Name'\" value='New Family Name'>
						<input type= 'submit' value='Start'>
						</form>
				</td></tr></table>"
	end
	
	toRet<<"<br /><br /><h3 style='display:inline; margin-bottom: 7px'>Our Turf &nbsp;</h3>"
	if (isHead?())
		toRet<<"<h6 style='display:inline'><a href='/newTurf'>[Add New]</a></h6> "
	end
	toRet<<"#{turfTable}"
	toRet<<"<br /><br /><h3 style='margin-bottom: 7px'>Their Turf &nbsp;</h3>"
	toRet<<"#{theirTurf}"
	toRet<<"</div>"
	return toRet
end

def getJoinExistingTable()
file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close


        db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)

	query="call ProjectInfo('#{$user['Emp_ID']}')"
	puts query
	results= db.query(query) 
	db.close()
	table="<table style='width:80%;'>	"
	table<<"<tr><td><h2>Or Join An Existing One</h2></td></tr>"
	table<<"<tr><td><h4><u>Name</u></h4></td><td><h4><u>Description</u></h4></td></tr>"
	results.each_hash do |project|
		name=project['Name']
		desc=project['Description']
		pid=project['ProjectID']
		table << "<tr><td>#{name}</td><td>#{desc}</td>"
		table << "<td><form action='/joinProject' method='Post'>
				<input type='hidden' name='pno' value=#{pid}></input>
				<input type='hidden' name='empID' value=#{$user['Emp_ID']}></input>
				<td><input type='submit' value='Join' ></input></td>
				</form></td></tr>"
	end
	table<<"</table>"		
	return table
end


def createProjectsTable(empID)
file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close


        db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)

	results= db.query "Select * from Works_On where Employee='#{empID}'"
	
	#debugging
	table="<tr><td><h4><u>Name</u></h4></td><td><h4><u>Description</u></h4></td><td><h4><u>Hours_worked</u></h4></td></tr>"
	results.each_hash do |project|
		pid=project['Project']
		query="Select * from Project where ProjectID='#{pid}'"
		detailRow = db.query(query).fetch_hash
		name=detailRow['Name']
		desc=detailRow['Description']
		hours=project['Hours_Worked']
		table << "<tr><td>#{name}</td><td>#{desc}</td><td><center>#{hours}</center></td>"
		table << "<td><form action='/addHours' method='Post' style='display:inline;>
				<input type='hidden' name='phours' value=#{hours}>
				<input type='hidden' name='pid' value=#{pid}>
				<input type='hidden' name='empID' value=#{empID}>
				<td><input type='submit' value='Add Hours' size='2'></td>
				<td><input type='number' name='addHrs' size='2' value='0' ></td></form></td>"
		
		table << "<td><form action='/quitProject' method='Post' style='display:inline'>
					<input type = 'hidden' name= 'projid' value = '#{pid}'>
					<input type = 'hidden' name= 'empid' value = '#{$user['Emp_ID']}'>
					<input type = 'submit' value= 'Quit'>
					</form></td>"
		if (isHead?())
			table<<"<td><form action='/delProject' method='Post' style='display:inline'>
					<input type ='hidden' name= 'projid' value='#{pid}'>
					<input type ='submit' value= 'X'>
					</form></td>"
		table<<"</tr>"
		end
	end
	db.close
	return table
end		

def getEmployeesTable()
	if (!isHead?())
		return ""
	end
	table="<table style='width:100%'><tr><td><h4><u>Name</u></h4></td><td><h4><u>DoB</u></h4></td><td><h4><u>Address</u></h4></td><td><h4><u>Prison</u></h4></td></tr>"
	db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
	results= db.query "Select * from Employee where Family='#{$user['Family']}'"
	results.each_hash do |emp|
		name=emp['Name']
		dob=emp['DOB']
		address=emp['Address']
		prison=emp['Prison']
		id=emp['Emp_ID']
		table << "<tr><td>#{name}</td><td>#{dob.chomp("00:00:00")}</td><td>#{address}</td><td>#{prison}</td>"
		if (id!=$user['Emp_ID'])
		table << "<td><form action='/fireEmp' method='Post' style='display:inline'>
					<input type = 'hidden' name= 'id' value = '#{id}'>
					<input type = 'submit' value= 'Fire'>
					</form></td></tr>"
		end
	end
	table<< "</table>"
	db.close()
	return table
end

def createEnemiesTable()
file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close


        db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)

	results=db.query "Select Employee.Name as famHead, Enemy_Of.Family2 as famName from Enemy_Of, Family, Employee where Enemy_Of.Family1 ='#{$user['Family']}' and Enemy_Of.Family2=Family.Name and Family.Head=Employee.Emp_ID"
	table="<table style='width:100%;'>"
	table<< "<tr><td><h4><u>Family Name</u></h4></td><td><h4><u>Family Head</u></h4></td></tr>"
	results.each_hash do |enemy|
		head=enemy['famHead']
		name=enemy['famName']
		table << "<tr><td>#{name}</td><td>#{head}</td></tr>"
	end
	table << "</table>"
	db.close
	return table
end
	
post '/joinProject' do
file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close


        db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)

	pno=db.escape_string(params['pno'])
	empID=db.escape_string(params['empID'])
	puts "join project: empID=#{params['empID']}, pno = #{params['pno']}"
	result= db.query "call JoinProject('#{empID}','#{pno}')"
	db.close()
	error = result.fetch_row()[0]
	if error=='1' then
		flash[:error]="You are not an employee"
	elsif error=='2' then
		flash[:error]="Invalid project number"
	end
	redirect "/welcome"

end

post '/createFamily' do
	if (params['famName']!=nil)#User wasn't previously part of a family
           file = File.new("/var/www/secret","r")
           dbUser = file.gets.chomp
           dbPass = file.gets.chomp
          encrypt = file.gets.chomp
          file.close


        db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)

		famName=db.escape_string(params['famName'])
		result=db.query "call createFamily('#{famName}', '#{$user['Emp_ID']}')"
		db.close()
		error = result.fetch_row()[0]
		if error=='1' then
			flash[:error]="Family name is null"
		elsif error=='2' then
			flash[:error]="Family already exists!"
		elsif error=='3' then
			flash[:error]="You're already in a family"	#shouldn't happen
		elsif error=='0'
			$user['Family']=famName
		end
		redirect '/welcome'
	end
end

post '/addHours' do
file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close


        db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)

	addhrs =db.escape_string(params['addHrs'])
	result= db.query "call addHours('#{params['empID']}','#{params['pid']}','#{addhrs}')"
	db.close()
	error = result.fetch_row()[0]

	if error=='1' then
		flash[:error]="Project doesn't exist in DB"
	elsif error=='2' then
		flash[:error]="You must enter a valid number of hours"
	elsif error=='3' then
		flash[:error]="You are not a real employee"
	end
	redirect "/welcome"
end

def createTurfTable()
file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close


        db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)

	result=db.query "select * from Turf where Controlling_Family='#{$user['Family']}'"
	table="<table style='width:100%;'>"
	table<< "<tr><td><h4><u>Region</u></h4></td><td><h4><u>City</u></h4></td><td><h4><u>State</u></h4></td><td><h4><u>Mayor</u></h4></td></tr>"
	db.close()
	result.each_hash do |turf|
		state=turf['State']
		city=turf['City']
		region=turf['Region']
		mayor=turf['Mayor']
		table<< "<tr><td>#{region}</td><td>#{city}</td><td>#{state}</td><td>#{mayor}</td></tr>"
	end
	table<< "</table>"
	return table
end

def createTheirTurfTable()
file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close


        db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)

	result=db.query "call AllOwnedTurf('#{$user['Family']}')"
	table="<table style='width:100%;'>"
	table<< "<tr><td><h4><u>Region</u></h4></td><td><h4><u>City</u></h4></td><td><h4><u>State</u></h4></td><td><h4><u>Controlling Family</u></h4></td></tr>"
	db.close()
	result.each_hash do |turf|
		state=turf['state']
		city=turf['city']
		region=turf['region']
		fam=turf['name']
		table<< "<tr><td>#{region}</td><td>#{city}</td><td>#{state}</td><td>#{fam}</td>#{takeOverButton(state, city, region)}</tr>"
	end
	table<< "</table>"
	return table
end

def takeOverButton(state, city, region)
	if (!isHead?)
		return ""
	end
	puts "in button, city= #{city}"
	return "<td><form action='/takeOverTurf' method='post'>
					<input type= 'submit' value='Take Over'>
					<input type='hidden' name='state' value='#{state}'>
					<input type='hidden' name='city' value='#{city}'>
					<input type='hidden' name='region' value='#{region}'>
					</form>
			</td>"
end
		
def createProjectButton()
	if (isHead?)
		return "<tr><td><form action='/createProject' method='post'>
					<input type= 'submit' value='Create New Project'>
					</form>
			</td></tr>"
	end
	return ""
end

post '/prisonSearch' do
	if isValidPrison(params['prisonName'])
		redirect "/prison?name=#{params['prisonName']}"
	end
	"<html><body><h1>The prison you searched for doesn't exist</h1>
	<form action='/welcome' method='get' target='_top' >
			<input type='submit' value='Back'></form></td></tr>"
end
		
		
post '/delProject' do
	file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close


        db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)

	result=db.query "Delete from Project where ProjectID='#{params['projid']}'"
	redirect '/welcome'
end

post '/quitProject' do
	pid=params['projid']
	file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close


        db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)

	result=db.query "Delete from Works_On where Employee='#{$user['Emp_ID']}' and Project='#{pid}'"
	redirect '/welcome'
end
	
	
def getEmployeeButton()
	return "<h6 style='display:inline'><a href='/register'>Add Employee</a></h6>"
end

post '/fireEmp' do 
file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close


        db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)

	db.query("delete from Employee where Emp_ID=#{params['id']}")
	db.close()
	redirect '/welcome'
end
