require "thor"
require "mysql2"

class DatabaseConnection 
    def initialize(host,username,password,database)
        @host = host
        @username = username
        @password = password
        @database = database
    end

    def establishConnection 
        @connection =  Mysql2::Client.new(
           :host     => @host, 
           :username => @username,     
           :password => @password,    
           :database => @database,           
        ) 
        return @connection;
    end
end



class RubyAddressBook < Thor  
    database = DatabaseConnection.new("127.0.0.1","root","","RailsAPI");
    $connection = database.establishConnection()


     desc "AddnewContact name phoneNo address","Add new Contact to your Adress Book"

     def AddnewContact(name,phoneNo,address)
         sql = "INSERT INTO addressBook(name,phoneno,address) VALUES ('#{name}','#{phoneNo}','#{address}')";
         $connection.query(sql);
     end

     desc "deleteContact name","Delete Contact"

     def deleteContact(name)
         sql = "DELETE FROM addressBook WHERE name = '#{name}'"
     end


     desc "Viewbyalphabetic alphabet","View by alphabetic"

     def Viewbyalphabetic(alphabet)
        sql = "SELECT * FROM addressBook WHERE name LIKE '#{alphabet}%'"
        results = $connection.query(sql);
        results.each do |row|
            print "#{row['id']})" 
            print "#{row['name']}\t"  
            print "#{row['phoneno']}\t"  
            print "#{row['address']}\t"  
            puts ""
          end
       end

     desc "ViewAllcontact","View All Contact"

     def ViewAllcontact
        sql = "SELECT * FROM addressBook"
        results = $connection.query(sql);
        results.each do |row|
            print "#{row['id']})" 
            print "#{row['name']}\t"  
            print "#{row['phoneno']}\t"  
            print "#{row['address']}\t"  
            puts ""
          end
       end
    end 

    RubyAddressBook.start(ARGV)