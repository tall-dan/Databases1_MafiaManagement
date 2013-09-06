def updateEmpHTML()

	name=$user['Name']

	dob=$user['DOB']

	addr=$user['Address']

	fam=$user['Family']

	prison=$user['Prison']

	uname=$user['Username']

	empID=$user['Emp_ID']

	return "
<html>
<head>
<body background=\"http://www.faniq.com/images/blog/5e42ef5796b623c1cddf5ff36c85bab1.jpg\"alt=\"Pulpit rock\" width=\"1920\" height=\"955\">
</head>
	  <body>
	    <font face='verdana,arial' size=-1><center>
		<table cellpadding='2' cellspacing='0' border='5' id='ap_table'>
	  	<tr><td bgcolor='black'>
	    <table cellpadding='15' cellspacing='5' border='2' width='100%'><tr><td bgcolor='black' align=center style='padding:2;padding-b


ottom:4'><b>


	    <font size=7 color='white' face='verdana,arial'><b>Edit My Info</b></th></tr></font>
    	<tr><td bgcolor='white' style='padding:25'><br>
    	<form action='/validateUpdate' method='post' target='_top' style='display:inline'>
				<div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Name:<input type='text' name='name' value='#{name}' readonly style=\"padding:15\"><br></div>


				<div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">User Name:<input type='text' name='username' value='#{uname}' readonly style=\"padding:15\"><br></div>


				<div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Password:<input type='password' name='password' style=\"padding:15\"><br></div>


				<div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">New Password:<input type='password' name='newPassword' style=\"padding:15\"><br></div>


				<div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Repeat New Password:<input type='password' name='cNewPassword' style=\"padding:15\"><br></div>


				<div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">DOB:<input type='text' name='dob' value='#{dob}' readonly style=\"padding:15\"><br></div>


				<div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Address: <input type='text' value='#{addr}' name='address' style=\"padding:15\"><br></div>


				<div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Family: <input type='text' value='#{fam}' name='family' style=\"padding:15\"><br></div>


				<div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Prison: <input type='text' value='#{prison}' name='prison' readonly style=\"padding:15\"><br></div>


				<input type='hidden' value='#{empID}' name='empID'>


				<input type='submit' value='Submit'></form>


		#{getBackButton("welcome","get","display:inline")}</td></tr>


    <center>


    </table>





    </font>


</body>


    </html>"



end



post '/validateUpdate' do

        file = File.new("/var/www/secret","r")

        dbuser = file.gets.chomp

        dbpass = file.gets.chomp

        encrypt = file.gets.chomp

        file.close

	db= Mysql.new('127.0.0.1', dbuser, dbpass, 'MafiaTracker', 3306)

	password =db.escape_string(params["password"])

	newPassword =db.escape_string(params["newPassword"])

	cNewPassword =db.escape_string(params["cNewPassword"])

	address =db.escape_string(params["address"])

	family =db.escape_string(params["family"])

	prison =db.escape_string(params["prison"])

	empID =db.escape_string(params["empID"])

  result= db.query "call updateEmp('#{empID}', '#{family}', '#{address}', '#{password}', '#{newPassword}', '#{cNewPassword}','#{encrypt}')"

	#status codes: 1 family doesn't exist, 2 prison dne, 3 wrong password, 4 new != confirm)

	db.close();

	error = result.fetch_row()[0]

	puts "Error is #{error}"

	if (error=='1')
		puts "Incorrect old password"
		return "<html><body><p>Incorrect old password </p>#{getBackButton("updateEmp","get","")}"
	elsif (error=='2')
		puts "Passwords don't match"
		return "<html><body><p>Passwords don't match </p>#{getBackButton("updateEmp","get","")}"
	elsif (error=='3')
		puts "Family doesn't exist"
		return "<html><body><p>Family Doesn't Exist </p>#{getBackButton("updateEmp","get","")}"
	elsif (error=='0')
		$user=getInfoFromUname($user["Username"])
		puts "no error"
		redirect "/welcome"
	end

	

end

