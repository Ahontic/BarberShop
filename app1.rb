#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'



	def is_barber_exist? db, name
		db.execute('select * from Barbers where name=?', [name]).length > 0
	end

	def seed_db db, barbers

		barbers.each do |barber|
			if !is_barber_exist? db, barber
				db.execute 'insert into Barbers (name) values (?)', [barber]
			end
		end
	end


	def get_db
 		db = SQLite3::Database.new 'BarberShop.sqlite'
 		db.results_as_hash = true
 		return db
 	end

before do
	db = get_db
	@barbers = db.execute 'select * from barbers' 
end

 configure do
		db = get_db
		db.execute 'CREATE TABLE IF NOT EXISTS
		"users"
		(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"username" TEXT,
		"phone" TEXT,
		"datestamp" TEXT,
		"barber" TEXT,
		"color" TEXT)';
	
		db.execute 'CREATE TABLE IF NOT EXISTS
		"barbers"
		 ("id" INTEGER PRIMARY KEY AUTOINCREMENT,
		  "name" TEXT
		 )'

		seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehrmantraut']

		end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>!"			
end

get '/about' do
	erb :about
end

get '/showusers' do
	db = get_db

	@results = db.execute 'select*from Users order by id desc' 

	erb :showusers
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
		@datetime 	= params[:datetime]
		@barber		= params[:barber]
		@color		= params[:color]

		hh = { 
				:username => 'Введите имя', 
				:phone => 'Введите телефон',
				:datetime => 'Выберите дату'

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
	 	values(?, ?, ?, ?, ?)', [@username,@phone,@datetime,@barber,@color]

	 	@title 	=	"Thank You"
		@message = "Dear #{@username}, your master is #{@barber}, we'll be waiting for you at #{@datetime}, Color:#{@color}"
		

		
		f = File.open './public/users.txt', 'a'
		f.write "Barber: #{:barber} User: #{@username}, Phone: #{@phone}, Date and time: #{@datetime}, @{color}.\n"
		f.close

		erb :message
		
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
		@message = "Dear #{@username}, we'll be waiting for you at #{@datetime}"
		

		f = File.open './public/contacts.txt', 'a'
		f.write "User: #{@username}, Comment: #{@comments}\n"
		f.close

	end