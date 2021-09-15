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


class TodoApplication < Thor 
    
    database = DatabaseConnection.new("127.0.0.1","root","","RailsAPI");
    $connection = database.establishConnection()


    desc "addTask NAME" , "add a new task to your TODOlist"
    def addTask(name)
       sql = "INSERT INTO todo (name) VALUES ('#{name}')"
       $connection.query(sql);
    end

    desc "deleteTask NAME", "remove a task from your TODOlist"

    def deleteTask(name)
        sql = "DELETE FROM todo  WHERE  name = '#{name}'"
        $connection.query(sql);
    end
    
    desc "listallTask", "List all your todo list" 
    
    def listAlltask
        
        sql = "SELECT * FROM todo"
        results = $connection.query(sql);
        results.each do |row|
            print "#{row['id']})" 
            print "#{row['name']}\t"  
            puts ""
          end
    end
end

TodoApplication.start(ARGV);