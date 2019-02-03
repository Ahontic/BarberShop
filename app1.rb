#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


configure do
		db = SQLite3::Database.new 'BarberShop.sqlite'
		db.execute 'CREATE TABLE IF NOT EXISTS
		"users"
		(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"username" TEXT,
		"phone" TEXT,
		"datestamp" TEXT,
		"barber" TEXT,
		"color" TEXT)';
end


get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>!"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
		erb :contacts
end

post '/visit' do
		# user_name, phone, date_time
		@username 	= params[:username]
		@phone 		= params[:phone]
		@date 		= params[:date]
		@barber		= params[:barber]
		@color		= params[:color]

		hh = { 
				:username => 'Введите имя', 
				:phone => 'Введите телефон',
				:date => 'Выберите дату'

			}

#			hh.each do |key,value|
				# если параметр пуст
#				if params[key] == ''
					# переменной еррор присвоить value из хеша hh
					# а value из хеша hh это сообщение об ошибке
					# т.е. переменной еррор присвоить сообщение об ошибке
#					@error = hh[key]

					# вернуть представление visit
#					return erb :visit
#				end
#			end

	@error = hh.select {|key,_| params[key] == ""}.values.join(",")
	
	if @error != ''
		return erb :visit
	end

	db = get_db
	db.execute 'insert into
	users
	 (
	 	username,
	 	phone,
	 	datestamp,
	 	barber,
		color
	 )
	 	values(?, ?, ?, ?, ?)', [@username,@phone,@datestamp,@barber,@color]

	 	@title 	=	"Thank You"
		@message = "Dear #{@username}, your master is #{@barber}, we'll be waiting for you at #{@date}, Color:#{@color}"
		

		
		f = File.open './public/users.txt', 'a'
		f.write "Barber: #{:barber} User: #{@username}, Phone: #{@phone}, Date and time: #{@date}, @{color}.\n"
		f.close

		erb :message
		
end

 	def get_db
 		return SQLite3::Database.new 'BarberShop.sqlite'
 	end

 	post '/contacts' do
		# user_name, comments
		@username 	= params[:username]
		@comments 	= params[:comments]

		con = { 
				:username => 'Введите имя', 
				:comments => 'Оставьте комментарий ',
				
			}
	
	@error = con.select {|key,_| params[key] == ""}.values.join(",")

    if @error != ''	
        return erb :contacts
    end
		@message = "Dear #{@username}, we'll be waiting for you at #{@date}"
		

		f = File.open './public/contacts.txt', 'a'
		f.write "User: #{@username}, Comment: #{@comments}\n"
		f.close

end