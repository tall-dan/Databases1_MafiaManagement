use MafiaTracker;
delimiter //
create procedure login (IN user varchar(50),in pass varchar(50), in code varchar(50)) 
begin
	declare status int;
	declare dpass varchar(150);
	set dpass = (select Password from Employee where Username = user);
	#--First check to see if the username exists. If it doesn't, set the status code to 1.
	if not exists (select Username from Employee where Username = user) then set status= 1;
	#--Now check if the password is correct. If it isn't, set the status to 2.
	else 
	     #set dpass = aes_decrypt((select Password from Employee where Username = user), code);
	     #if (dpass <> pass) then set status = 2;
	     if (Binary (select Password from Employee where Username = user) <> pass) then set status = 2;
	     else set status = 0;
	     end if;
	end if;
	select status;
end //
delimiter ;
