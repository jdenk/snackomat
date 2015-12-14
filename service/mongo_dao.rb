require 'mongo'


client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'mydb')
client[:artists].insert_one({ name: 'FKA Twigs' })