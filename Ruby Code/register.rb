def getRegisterHtml()
"
<html>
<head>
<body background=\"http://shekoos.files.wordpress.com/2011/05/cle_mafia.jpg\"alt=\"Pulpit rock\" width=\"1920\" height=\"955\">
</head>
	  <body>
	    <font face='verdana,arial' size=-1><center>
		<table cellpadding='2' cellspacing='0' border='5' id='ap_table'>
	  	<tr><td bgcolor='black'>
	    <table cellpadding='15' cellspacing='5' border='2' width='100%'><tr><td bgcolor='black' align=center style='padding:2;padding-b
ottom:4'><b>
	    <font size=7 color='white' face='verdana,arial'><b>Add A Bro.</b></th></tr></font>
    
    	<tr><td bgcolor='white' style='padding:25'><br>
    	<form action='/checkNewUser' method='post' target='_top'>
    <div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">User Name:<input type='text' name='username' style=\"padding:15\"><br></div>
    <div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Password:<input type='password' name='password' style=\"padding:15\"><br></div>

 	<div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Name:<input type='text' name='name' style=\"padding:15\"><br></div>

 	<div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">DOB:<input type='text' name='dob' onfocus=\"this.value=''\"  onblur=\"if (this.value=='') this.value='YYYY/MM/DD'\" value='YYYY/MM/DD' style=\"padding:15\"><br></div>

    <div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Address: <input type='text' name='address' style=\"padding:15\"><br></div>

    <div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Family: <input type='text' name='family' value='#{$user['Family']}' readonly style=\"padding:15  \"><br></div>

    <div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Prison: <input type='text' name='prison' style=\"padding:15\"><br></div>

    <input type='submit' value='Submit'>
    <center>
    </table>
</form>
    </font>
</body>
    </html>"
end
