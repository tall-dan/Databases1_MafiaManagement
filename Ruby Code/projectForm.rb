def getProjectForm()

return 	"
<html>
<head>
<body background=\"http://parkerstech.com/wp-content/uploads/2013/01/mafia4.jpg\"alt=\"Pulpit rock\" width=\"1920\" height=\"955\">
</head>
	  <body>

	    <font face='verdana,arial' size=-1><center>

		<table cellpadding='2' cellspacing='0' border='5' id='ap_table'>

	  	<tr><td bgcolor='black'>

	    <table cellpadding='15' cellspacing='5' border='2' width='100%'><tr><td bgcolor='black' align=center style='padding:2;padding-b

ottom:4'><b>

	    <font size=7 color='white' face='verdana,arial'><b>New Project</b></th></tr></font>

    

    	<tr><td bgcolor='white' style='padding:5'><br>

    	<form action='/checkNewProject' method='post' target='_top'>

    <div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Name:<input type='text' name='pname'style=\"padding:15\"><br></div>

    <div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Description:<input type='text' name='pdesc'style=\"padding:15\"><br></div>

    <input type='submit' value='Submit'>

    <center>

    </table>

</form>

    </font>

</body>

    </html>"

end





post '/checkNewProject' do
	if (createProject(params["pname"], params["pdesc"]))

		redirect "/welcome?uname=#{$sessionUname}"

	else

		flash[:error] = "Invalid project name"

		redirect '/createProject'

	end

end



def createProject(pname,pdesc)
file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close
  db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)
  puts("#{$user['Family']}")

	result= db.query("call CreateProject('#{db.escape_string(pdesc)}','#{db.escape_string(pname)}', '#{$user['Family']}')")

	db.close()

	error = result.fetch_row()[0]

	if error == '1' then

		return false

	end

	return true;

end
