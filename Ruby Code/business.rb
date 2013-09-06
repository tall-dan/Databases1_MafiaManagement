post '/businessSearch' do
  file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close
	db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)
	result=db.query "select * from Business where Name='#{params['businessName']}'"
	db.close()
	retRows=result.num_rows()
	if (retRows==0)
		flash[:error]="Not valid businesss name"
	elsif (retRows==1)
		info=result.fetch_hash()
		getBusinessPage(info['ID'])
	else
		chooseFromBusinesses(result)
	end
end

get '/businessInfo' do
	getBusinessPage(params['busID'])
end

def getBusinessPage(busID)
	db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
	result=db.query "select * from Business where ID='#{busID}'"
	db.close
	info=result.fetch_hash
	name=info["Name"]
	state=info["state"]
	city=info["city"]
	region=info["region"]
	ownedBy=info["OwnedBy"]
	profit=info["Profit"]
	editOption=getEditOption()
	productsTable=createProductsTable(busID)
	takeButton=getTakeButton(busID, ownedBy, profit)
	legitButton=getLegitButton(busID,ownedBy)
	addProducts=addProductsButton(ownedBy,busID)	
	return 	"

<html> 
	<head>
		<title>#{name}</title>
		<body background=\"http://www.consultechglobal.com/wp-content/uploads/2012/07/money.jpg\" alt=\"Pulpit rock\" width=\"1920\" height=\"955\">
	</head>
	<body>
	<center>
		<table>
		<tr><td><h1 style='margin-top: 3px; margin-bottom: 2px'>#{name}</h1></td></tr>
		</table>		
	</center>
	<center>
		<h4 style='margin-top: 3px; margin-bottom: 2px'>#{region} #{city}, #{state}</h4>
		#{takeButton}
		#{legitButton}
	</center>	
	<br />	
	<h2>Our Products</h2>
	#{productsTable}
	<table>
		<tr><td>#{addProducts}</td><td>#{getBackButton("welcome","get","display:inline")}</td></tr>
	</table>
	</body>
</html>"

end

def addProductsButton(ownedBy, busID)
	table=""
	if (bossOfFamily()==ownedBy)
	table <<"<form action='/addProduct' method='post' style='display:inline'>
					<input type= 'submit' value='Add New Product'>
					<input type= 'hidden' value='#{busID}' name='busID'>
					</form>"
	end
	return table
end



def createProductsTable(busID)
	db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
	results= db.query "Select * from Sells where BusinessID=#{busID}"
	#debugging
	table="<table style='width:70%;'><tr><td><h4><u>Name</u></h4></td><td><h4><u>Manufacturing Cost</u></h4></td><td><h4><u>Sale Price</u></h4></td></tr>"
	results.each_hash do |product|
		pid=product['ProductID']
		query="Select * from Product where ID=#{pid}"
		detailRow = db.query(query).fetch_hash
		name=detailRow['Name']
		manfCost=detailRow['Manf_Cost']
		salePrice=detailRow['Sale_Price']
		table << "<tr><td>#{name}</td><td>#{manfCost}</td><td>#{salePrice}</td>"
		if (isHead?()) then
			table << getEditButton(name, manfCost,salePrice,pid,busID)
			table << getDeleteProductButton(pid,busID)
		end
		table<< getAddOrder(pid,busID,manfCost,salePrice)
		table<< "<tr><td height='25' </td> </tr>"
	end
	db.close
	return table
end	

def getEditButton(name,manfCost,salePrice,pid,busID)
return 		"<td><form action='/editProduct' method='Post' style='display:inline'>
					<input type='hidden' name='pname' value=#{name}>
					<input type='hidden' name='manfCost' value=#{manfCost}>
					<input type='hidden' name='salePrice' value=#{salePrice}>
					<input type='hidden' name='pid' value=#{pid}>
					<input type='hidden' name='busID' value=#{busID}>
					<input type='submit' value='Edit'>
					</form></td>"
end

def getAddOrder(pid,busID, manfCost, salePrice)
return "<td><form action='/addOrder' method='Post' style='display:inline'>
				<input type='hidden' name='busID' value=#{busID}>
				<input type='hidden' name='manfCost' value=#{manfCost}>
				<input type='hidden' name='salePrice' value=#{salePrice}>
				<input type='submit' value='Add Order' size='2'>
				<input type='number' name='qty' size='2' value='0' ></form></td>"
end

def getEditOption()
	if (isHead?())
		return "<td><h6 style='margin-top: 3px; margin-bottom: 2px'><a href='/updateBusiness'>Edit</a></h6></td>"
	end
	return ""
end

def getDeleteProductButton(pid,busID)
	return "<td><form action='/deleteProduct' method='Post' style='display:inline'>
					<input type='hidden' name='pid' value=#{pid}>
					<input type='hidden' name='busID' value=#{busID}>
					<input type='submit' value='X'>
					</form></td></tr>"
end

def chooseFromBusinesses(result)		
	table="<table style='width:70%;'>"
	table<< "<tr><td><h4><u>Name</u></h4><td><h4><u>Region</u></h4></td><td><h4><u>City</u></h4></td><td><h4><u>State</u></h4></td></td></tr>"
	result.each_hash do |business|
		id=business['ID']
		state=business['state']
		city=business['city']
		region=business['region']
		name=business['Name']
		table<< "<tr><td>#{name}</td><td>#{region}</td><td>#{city}</td><td>#{state}</td>"
		table<<"<td><form action='/businessInfo?busID=#{id}' method='Post'>
				<input type='submit' value='Select'></form></td></tr>"	
	end
	table<< "</table>"
	return "<!DOCTYPE=html>
	<html> 
	<head>

		<title>Choose a business</title>
	<body background=\"http://fc06.deviantart.net/fs8/i/2005/314/a/c/Question_mark_by_lacrimas.jpg\" alt=\"Pulpit rock\" width=\"1920\" height=\"955\">
	</head>
	<body>
		<center><h1>Did you mean...</h1></center>
		#{table}
	#{getBackButton('welcome','get','')}
	</body>
	</html>"
end 



def getTakeButton(busID, ownedBy, profit)
	line="<table><tr><td><h5>Profit: $#{profit} &nbsp &nbsp &nbsp  Owned By: "
	if ownedBy==''
		value="Take Over"
		line<<"No one</h5></td> "
	elsif ownedBy==$user['Family']
		line<<"#{ownedBy}</h5></td></tr></table>"
		return line
	else
		value="Acquire"
		line<<"#{ownedBy}</h5></td>"
	end
	if (isHead?)
		line<<"<td><form action='/acquireBusiness' method='post'>
				<input type='submit' value='#{value}'>
				<input type='hidden' name='ownedBy' value='#{ownedBy}'>
				<input type='hidden' name='busID' value='#{busID}'></form></td>"
	end
	line<<"</tr></table>"
	return line
end

def getLegitButton(busID,ownedBy)
	if (ownedBy!=$user['Family'])
		return "<p> Is legit? #{isLegit?(busID)}</p>"
	end
	action=""
	method=""
	value=""
	setLegitTo="1"
	if (!isLegit?(busID))
		value="Is a front"
	else
		value="Is legit"
		setLegitTo="0"
	end
	if (!isHead?()) 
		method="get"
		action="/businessInfo?busID=#{busID}"
	else
		action="/toggleLegit"
		method="post"
	end
	return "<form action='#{action}' method='#{method}'>
			<input type='hidden' value='#{busID}' name='busID'>
			<input type='submit' value='#{value}'>
			<input type='hidden' value='#{setLegitTo}' name='setLegit'>
			</form>"
		
end

post '/acquireBusiness' do
	db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
	if params['ownedBy']==''
		proc="call takebusiness('#{params['busID']}','#{$user['Family']}')"
	else
		proc="call StealBusiness('#{params['busID']}','#{$user['Family']}')"
	end
	result=db.query(proc)
	error = result.fetch_row()[0]
	if (error==1)
		flash[:error]="Catch error 1: not a real business"
	end
	redirect "/businessInfo?busID=#{params['busID']}"
end

	
post '/addOrder' do
	db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
	query="call calcprofit(#{params['busID']},#{params['manfCost']},#{params['salePrice']},#{params['qty']})"
	puts query
	result=db.query(query)
	db.close()
	error =result.fetch_row()[0]
	addr="businessInfo?busID=#{params['busID']}"
	if (error==1)
		puts "mcost or sprice are <0"
		return "<html><body><p>All prices must be >=0 </p>#{getBackButton(addr,"post","")}"	
	elsif(error==2)
		puts "Quantity is less than 0"
	end
	redirect "/#{addr}"
end

post '/toggleLegit' do
	db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
	db.query("update Business set legit = #{params['setLegit']} where ID=#{params['busID']} ")
	db.close()
	redirect "/businessInfo?busID=#{params['busID']}"
end
