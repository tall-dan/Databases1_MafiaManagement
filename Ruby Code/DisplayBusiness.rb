#This page displays the business the family owned

def getBusinessHTML()
	
	id = $ user['Emp_ID']
	name = $user['Name']
	family = $USER['Family']
	BusinessTable = createBusinessTable()
	return "
 <html>
	<head >
		<title>My business</title>
	</head>
	<body>
	<center>
	           <table>
			<tr>
				<td><h1> My business</h1></td>
			</tr>
		   </table>
	</center>
	</br>
	<talbe>
		<tr><td width=600>
