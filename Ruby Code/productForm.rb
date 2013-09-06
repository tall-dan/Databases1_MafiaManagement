post '/editProduct' do
	return newProductForm(params['pid'], params['pname'],params['manfCost'],params['salePrice'],params['busID'])
end

def newProductForm(pid, name,manfCost,salePrice,busID)
addr="businessInfo?busID=#{busID}"
return 	"<html>
<head>
<body background=\"http://moneymagnetmafia.com/wp-content/uploads/2012/07/00moneymagnetmafia341.jpg\"alt=\"Pulpit rock\" width=\"1920\" height=\"955\">
</head>
	  <body>
	    <font face='verdana,arial' size=-1><center>
		<table cellpadding='2' cellspacing='0' border='5' id='ap_table'>
	  	<tr><td bgcolor='black'>
	    <table cellpadding='15' cellspacing='5' border='2' width='100%'><tr><td bgcolor='black' align=center style='padding:2;padding-bottom:4'><b>
	    <font size=7 color='white' face='verdana,arial'><b>Update Product</b></th></tr></font>
    	<tr><td bgcolor='white' style='padding:25'><br>
    	<form action='/updateProduct' method='post' target='_top' style='display:inline'>
		<div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Name:<input type='text' name='name' value='#{name}' readonly style=\"padding:15\"><br></div>
    <div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Manufacturing Cost:<input type='number' name='manfCost' onfocus=\"this.value=''\"  onblur=\"if (this.value=='') this.value='#{manfCost}'\" value='#{manfCost}' style=\"padding:15\"><br></div>
    <div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Sale Price:<input type='number' name='salePrice' onfocus=\"this.value=''\"  onblur=\"if (this.value=='') this.value='#{salePrice}'\" value='#{salePrice}' style=\"padding:15\"><br></div>
	<input type='hidden' value='#{pid}' name='pid'>
	<input type='hidden' value='#{busID}' name='busID'>
    <input type='submit' value='Submit' ></form>
	#{getBackButton(addr,'post','display:inline')}</td></tr>
	<center>
	</table>
</form>
    </font>
	</body>
    </html>"
end


post '/updateProduct' do
	
file = File.new("/var/www/secret","r")
  dbUser = file.gets.chomp
  dbPass = file.gets.chomp
  encrypt = file.gets.chomp
  file.close


        db= Mysql.new('127.0.0.1', dbUser, dbPass, 'MafiaTracker', 3306)
	price=db.escape_string(params['salePrice'])
	mcost=db.escape_string(params['manfCost'])
	query="call UpdateProduct(#{params['pid']},'#{params['name']}',#{mcost},#{price}, #{$user['Emp_ID']})"
	puts query
	result=db.query(query)
	error = result.fetch_row()[0]
	db.close()
	
	addr="businessInfo?busID=#{params['busID']}"
	if (error=='1')
		puts "Null product name"
		return "<html><body><p>No product specified</p>#{getBackButton(addr,"post","")}"
	elsif (error=='2')
		puts "mcost or sprice are <0"
		return "<html><body><p>All prices must be >=0 </p>#{getBackButton(addr,"post","")}"
	elsif (error=='3')
		puts "User isn't a head"
		return "<html><body><p>You're not the head of a family </p>#{getBackButton(addr,"post","")}"
	elsif (error=='4')
		puts "pid invalid"
		return "<html><body><p>Invalid product </p>#{getBackButton(addr,"post","")}"
	elsif (error=='0')
		redirect "/businessInfo?busID=#{params['busID']}"
	end

end

post '/addProduct' do
addr="businessInfo?busID=#{params['busID']}"

return 	"
<html>
<head>
<body background=\"http://parkerstech.com/wp-content/uploads/2013/01/mafia4.jpg\"alt=\"Pulpit rock\" width=\"1920\" height=\"955\">
</head>
	  <body>
	    <font face='verdana,arial' size=-1><center>
		<table cellpadding='2' cellspacing='0' border='5' id='ap_table'>
	  	<tr><td bgcolor='black'>
	    <table cellpadding='15' cellspacing='5' border='2' width='100%'><tr><td bgcolor='black' align=center style='padding:2;padding-bottom:4'><b>
	    <font size=7 color='white' face='verdana,arial'><b>New Product</b></th></tr></font>
    	<tr><td bgcolor='white' style='padding:5'><br>
    	<form action='/makeNewProduct' method='post' target='_top'  style='display:inline'>
    <div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Name:<input type='text' name='name' onfocus=\"this.value=''\"  onblur=\"if (this.value=='') this.value='Product Name'\" value='Product Name' style=\"padding:15\"><br></div>
    <div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Manufacturing Cost:<input type='number' name='manfCost' onfocus=\"this.value=''\"  onblur=\"if (this.value=='') this.value='0'\" value='0' style=\"padding:15\"><br></div>
    <div style=\"line-height: 80px;\"><img src=\"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ37wa66z4J04e6EnCXvy5x1UcSXWqrTeBGyna_hwpWqWyCTgvVHCXIDQ\"alt=\"Pulpit rock\" width=\"25\" height=\"25\">Sale Price:<input type='number' name='salePrice' onfocus=\"this.value=''\"  onblur=\"if (this.value=='') this.value='0'\" value='0' style=\"padding:15\"><br></div>
    <input type='hidden' value='#{params['busID']}' name='busID'>
	<input type='submit' value='Submit'></form>#{getBackButton(addr,"post","display:inline")}</td>
    <center>
    </table>
	
    </font>
	</body>
    </html>"

end

post '/makeNewProduct' do 
	db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
	name=params['name']
	mc=params['manfCost']
	sp=params['salePrice']
	bID=params['busID']
	query="call AddProduct('#{name}',#{mc},#{sp},#{bID})"
	puts query
	#query="call UpdateProduct(#{params['pid']},'#{params['name']}',#{mcost},#{price}, #{$user['Emp_ID']})"
	result=db.query(query)
	db.close()
	
	error = result.fetch_row()[0]
	addr="businessInfo?busID=#{params['busID']}"
	
	if (error=='2')
		puts "Null product name"
		return "<html><body><p>No product specified</p>#{getBackButton(addr,"post","")}"
	elsif (error=='1')
		puts "mcost or sprice are <0"
		return "<html><body><p>All prices must be >=0 </p>#{getBackButton(addr,"post","")}"
	elsif (error=='3')
		puts "Specified business doesn't exist"
		return "<html><body><p>Specified business doesn't exist</p>#{getBackButton(addr,"post","")}"
	elsif (error=='0')
		redirect "/#{addr}"
	end
end


def getDeleteButton(pid,busID)
	return "<td><form action='/deleteProduct' method='Post'>
					<input type='hidden' name='pid' value=#{pid}>
					<input type='hidden' name='busID' value=#{busID}>
					<input type='submit' value='X' size='2'>
					</form></td></tr>"
end

post '/deleteProduct' do
	addr="businessInfo?busID=#{params['busID']}"
	db= Mysql.new('127.0.0.1', 'csse', 'mafiatracker', 'MafiaTracker', 3306)
	db.query("delete from Sells where BusinessID=#{params['busID']} and ProductID=#{params['pid']}")
	db.close()
	redirect "/#{addr}"
end
