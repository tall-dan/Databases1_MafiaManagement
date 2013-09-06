def newTurfForm()

return 	"<html>
<head>
<body background=\"http://moneymagnetmafia.com/wp-content/uploads/2012/07/00moneymagnetmafia341.jpg\"alt=\"Pulpit rock\" width=\"1920\" height=\"955\">
</head>

	  <body>


	    <font face='verdana,arial' size=-1><center>


		<table cellpadding='2' cellspacing='0' border='5' id='ap_table'>


	  	<tr><td bgcolor='black'>


	    <table cellpadding='15' cellspacing='5' border='2' width='100%'><tr><td bgcolor='black' align=center style='padding:2;padding-bottom:4'><b>
	    <font size=7 color='white' face='verdana,arial'><b>Acquire New Turf</b></th></tr></font>
    	<tr><td bgcolor='white' style='padding:25'><br>
    	<form action='/checkNewTurf' method='post' target='_top'>
    <div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">State:<input type='text' name='state' style=\"padding:15\"><br></div>


    <div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">City:<input type='text' name='city' style=\"padding:15\"><br></div>


	<div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Region:<input type='text' name='region' style=\"padding:15\"><br></div>


	<div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Mayor:<input type='text' name='mayor' style=\"padding:15\"><br></div>


    <input type='submit' value='Submit'></form>


	#{getBackButton('welcome','get','display:inline')}</td></tr>


    <center>


    </table>


</form>


    </font>


	</body>


    </html>"

end





post '/checkNewTurf' do

	if (createTurf(params['state'],params['city'],params['region'], params['mayor']))

		redirect "/welcome"

	else

		flash[:error] = "Invalid project name"

		redirect '/newTurf'

	end

end



def createTurf(state, city, region, mayor)

file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close


        db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)

	query="call addTurf('#{db.escape_string(state)}','#{db.escape_string(city)}', '#{db.escape_string(region)}', '#{db.escape_string(mayor)}','#{$user['Family']}')"
	puts query
	result= db.query(query)
    puts "num_rows returned from addTurf: #{result.num_rows}"
    error = result.fetch_row()[0]
	db.close();
	if (error == '1')
		return false
	elsif (error=='2')
		return false
	elsif (error=='3')
		return false;
	elsif (error=='4')
		return false;
	end
	return true;

end



post '/takeOverTurf' do #going to redirect to welcome no matter what, so no need for a helper method

	db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)

	puts "City= #{params['city']}, after escape =#{db.escape_string(params['city'])}"

	result= db.query "call takeoverTurf('#{$user['Family']}','#{db.escape_string(params['state'])}','#{db.escape_string(params['city'])}', '#{db.escape_string(params['region'])}')"

	db.close()

	error = result.fetch_row()[0]

	if error == '1' then

		flash[:error] = "No Family entered"

	elsif error=='2' then

		flash[:error] = "Turf is left blank"

	elsif error=='3' then

		flash[:error] = "Family does not exist"

	elsif error=='4' then

		flash[:error] = "Turf does not exist"

	end

	redirect '/welcome'

end

