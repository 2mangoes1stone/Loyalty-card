class Person
    
@@user_details = []

    def initialize(username)
        @username = username
        @@user_details << username
    end

    def gather_details
        puts "please enter your name"
        name = gets.chomp

        puts "Please enter your DOB(yyyy/mm/dd)"
        dob = gets.chomp
    end
end

class LoyaltyCard

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
          new_card = LoyaltyCard.new(username)
          new_person = Person.new(username)
          return self.get_points
        else
         puts "Sorry, that name is already taken, please enter a new name."
          return self.create_new_card
        end    
    end

    def self.get_points_option_1
        target = open("#{@username}.txt", "r+")
        points = target.read.to_i
        points  = points + 5
        target.rewind
        target.write(points)
        puts "Your current points balance is #{points}"
        target.close
    end

    def self.get_points_option_2
        target = open("#{@username}.txt", "r+")
        points = target.read.to_i
        points  = points + 10
        target.rewind
        target.write(points)
        puts "Your current points balance is #{points}"
        target.close
    end

    def self.get_points
        puts "What would you like?"
        puts "1.Small Coffee or 2.Large Coffee"
        option = gets.chomp
        case option
            when "1"
                return self.get_points_option_1
            when "2"
                return self.get_points_option_2
        end
    end

    def self.access_existing_card
        puts "please enter your username"
        @username = gets.chomp
        if has_username?(@username)
            file = open("#{@username}.txt", "r+")
            points = file.read.to_i
            puts "Your current points balance is #{points}"
            self.check_for_redemption
        else
            puts "that username does not exit. Please enter correct username."
            return self.access_existing_card
        end
    end
    
    def self.check_for_redemption
        target = open("#{@username}.txt", "r+")
        points = target.read.to_i
        if points >= 30
            return self.redeem_points
        else
            return self.get_points    
        end
    end

    def self.redeem_points
        target = open("#{@username}.txt", "r+")
        points = target.read.to_i
        puts "You can redeem 30 points for a well earned coffee 😀"
        puts "Would you like to reedeem or keep going? y/n"
        choice = gets.chomp
        if choice == "y"
            points = points - 30
            puts points
            puts "One small coffee coming up."
            target.rewind
            target.write(points)
            target.close
        else
            return self.get_points
        end
    end
end

def start
    puts "Hi, welcome welcome."
    puts "Read for some yummy coffee??"
    puts "But first, do you have an account with us? y/n"
    answer =  gets.chomp
    case answer
        when "y"
            return LoyaltyCard.access_existing_card
        when "n"
            return LoyaltyCard.create_new_card
    end
end

start
