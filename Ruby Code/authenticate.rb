

def authenticate(username, password)
  file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close
  puts "dbUser is #{dbUser}--dbPass is #{dbPass}--encrypt is #{encrypt}--"
  db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)
  sanitizedUser =db.escape_string(username)
  sanitizedPass =db.escape_string(password)
  result= db.query("call Login('#{sanitizedUser}','#{sanitizedPass}','#{encrypt}')")
  error = result.fetch_row()[0]
  puts "************************"
  puts "The result is #{error}"
  db.close();
  if error == '1' then
    puts "Username does not exist in DB"
    return false
  elsif error =='2' then
    puts "Incorrect password"
    return false
  end
  
  $user=getInfoFromUname(sanitizedUser)
  return true  
end


def getAuthenticateHTML()
return "<html>
<head>
<body background=\"http://sound-and-vision.org/wp-content/uploads/2012/01/P12167591.jpg\"alt=\"Pulpit rock\" width=\"1920\" height=\"955\">
</head>
<body>
<center><table cellpadding='1' cellspacing='0' border='5' id='ap_table'>
<tr><td bgcolor='white'><table cellpadding='20' cellspacing='12' border='0' width='100%'><tr>
<p style=\"text-align: center;\"><strong style=\"font-size: 250%;\">Mafia Manager</strong></p>
<tr><td bgcolor='white' style='padding:20'><br>
<form action='/authenticate' method='post' target='_top' >
<img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"50\" height=\"50\">User Name: <input type='text' name='Username'style=\"padding:15\"><br>
<img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"50\" height=\"50\">Password:  <input type='password' name='password'style=\"padding:15\"><br>
<center><table>
<input type='submit' value='Submit'>
</form>
<tr><td colspan=2>
</td></tr></table></td></tr></table>
</body>
</html>"


end 
