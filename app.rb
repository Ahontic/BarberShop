require 'sqlite3'

db = SQLITE3::Database.new 'test.sqlite3'

db.execute "INSERT INTO Cars (Name,Price) VALUES ('Jaguar', 999999)"

db.close