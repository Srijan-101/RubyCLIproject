require 'thor'
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

class ExpenseTracker < Thor 
    database = DatabaseConnection.new("127.0.0.1","root","","RailsAPI");
    $connection = database.establishConnection()


     desc "Additem name quantity price","Add item name and price"
     def Additem(name,quantity,price)
         quantity = quantity.to_i
         price = price.to_i
         totalPrice = quantity * price;
         sql = "INSERT INTO expense(name,quantity,price,totalPrice) VALUES ('#{name}','#{quantity}',#{price},#{totalPrice})";
         $connection.query(sql);
     end

     desc "Deleteitem name","Delete an item from list"
     def Deleteitem(name)
        sql = "DELETE FROM expense WHERE name = '#{name}'"
     end

     desc "viewAll" , "View all with total"
     def viewAll 
        sql = "SELECT * FROM expense"
        results = $connection.query(sql);
        totalPrice = 0;
           print "Id\t"
           print "Name\t"
           print "Quantity\t"
           print "Price\t"
           print "Totalprice\t"
           puts " "
        results.each do |row|
            print "#{row['id']})\t" 
            print "#{row['name']}\t"  
            print "#{row['quantity']}\t\t"  
            print "$#{row['price']}\t"  
            print "$#{row['totalprice']}\t"  
            puts ""
            totalPrice = totalPrice + row['totalprice'];
          end
          puts "------------------------------------------"
          print "Total-price : $#{totalPrice}"  
     end
end


ExpenseTracker.start(ARGV);