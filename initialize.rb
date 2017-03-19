require 'date'
require 'yaml'
require 'psych'

class Person
    
# user_details = []


attr_accessor :username, :full_name, :dob, :password

    def initialize(username, full_name, dob, password)
        @username = username
        @full_name = full_name
        @dob = dob
        @password = password
    end


    def save_user_details(username, full_name, dob, password)
        user_details = {username: username, full_name: full_name,dob: dob, password: password }
        target = open("person_details.yml")
        File.open("person_details.yml", "a+") do |file|
            file.write(user_details.to_yaml)
        end
        return LoyaltyCard.get_points(@username)
    end

    def self.check_password(username, password)
        # @username = username
        # @password = password
        # puts @password
       hash_arr = Psych.load_stream(File.read('person_details.yml'))
    a = hash_arr.select { |hash| hash[:username].include?(username) }
    # puts a.inspect
    i =  a[0][:password]
    # puts i
    # puts password
        if 
            i == password
            return LoyaltyCard.access_account(username)
        else 
            puts "Incorrect username & password combination, please try again"
            return LoyaltyCard.access_existing_card
        end            
   end
end

class LoyaltyCard

attr_accessor :username, :full_name, :dob, :password
    @@list = []

    def initialize(username)
        @username = username
        file = File.new("#{@username}.txt", "w+");
        file.write("0");
        file.close
        @@list << username
        self.class.add_username(username)
    end

    def self.read_usernames
        target = File.read("username_file_array.txt")
        return target.split("\n")
    end

    def self.has_username?(username)
        usernames = read_usernames
        return usernames.include?(username)
    end

    def self.add_username(username)
        target = open("username_file_array.txt", "a+")
        target.write("\n")
        target.write(username)
        target.close
    end

    def self.create_new_card
        puts "Please enter a desired username"
        username = gets.chomp
        unless has_username?(username)
          puts "Please enter you full name"
          full_name = gets.chomp
          puts "Please enter you DOB(yyyy-mm-dd)"
          dob = gets.chomp
          puts "Please choose a secure password"
          password = gets.chomp
          new_card = LoyaltyCard.new(username)
          new_person = Person.new(username, full_name, dob, password)
          return new_person.save_user_details(username, full_name, dob, password)
        #   return self.get_points
        else
         puts "Sorry, that name is already taken, please enter a new name."
          return self.create_new_card
        end    
    end

    def self.get_points_option_1(username)
        target = open("#{username}.txt", "r+")
        points = target.read.to_i
        points  = points + 5
        target.rewind
        target.write(points)
        puts "Your current points balance is #{points}"
        puts "Thank you, see you again soon 😀"
        target.close
    end

    def self.get_points_option_2(username)
        target = open("#{username}.txt", "r+")
        points = target.read.to_i
        points  = points + 10
        target.rewind
        target.write(points)
        puts "Your current points balance is #{points}"
        puts "Thank you, see you again soon 😀"
        target.close
    end

    def self.get_points(username)
        puts "What would you like?"
        puts "1.Small Coffee or 2.Large Coffee"
        option = gets.chomp
        case option
            when "1"
                return self.get_points_option_1(username)
            when "2"
                return self.get_points_option_2(username)
        end
    end

    def self.access_account(username)
        file = open("#{username}.txt", "r+")
        points = file.read.to_i
        puts "Your current points balance is #{points}"
        self.check_for_redemption(username)
    end

    def self.access_existing_card
        puts "please enter your username"
        username = gets.chomp
        if has_username?(username)
            puts "please enter your password"
            password = gets.chomp
             return Person.check_password(username, password)
        else
            puts "that username does not exit. Please enter correct username."
            return self.access_existing_card
        end
    end
    
    def self.check_for_redemption(username)
        target = open("#{username}.txt", "r+")
        points = target.read.to_i
        if points >= 30
            return self.redeem_points(username)
        else
            return self.get_points(username)    
        end
    end

    def self.redeem_points(username)
        target = open("#{username}.txt", "r+")
        points = target.read.to_i
        puts "You can redeem 30 points for a well earned coffee 😀"
        puts "Would you like to reedeem or keep going? y/n"
        choice = gets.chomp
        if choice == "y"
            points = points - 30
            puts points
            puts "One small coffee coming up."
            puts "Your current points balance is #{points}"
            target.rewind
            target.write(points)
            target.close
        else
            return self.get_points(username)
        end
    end
end

def start
    puts "Hi, welcome welcome."
    puts "Ready for some yummy coffee??"
    puts "But first, do you have an account with us? y/n(press 1 for admin access)"
    answer =  gets.chomp
    case answer
        when "y"
            return LoyaltyCard.access_existing_card
        when "n"
            return LoyaltyCard.create_new_card
    end
end

start