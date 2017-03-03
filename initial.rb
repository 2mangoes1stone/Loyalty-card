class LoyaltyCard
  #file "#{@username}.txt"

  @@cards = []

  # boby = Customer.new(username: "boby123")
  def initialize(username)
    @username = username
    file = File.new("#{@username}.txt", "w+");
    file.write("0");
    file.close
    @@cards << username
    LoyaltyCard.add_username(username)
    # txt = open("username_file_array.txt")
    # puts txt.read
    puts "Your current balance is 0"
  end

#   def check_username(username)
#     @@cards.include?(username)
#   end 

  # Handle working with username_file_array.txt file

  def self.read_usernames
    target = File.read("username_file_array.txt")
    # puts target
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
      print "Please enter a desired username?"
      @username = gets.chomp
      unless has_username?(@username)
          card = LoyaltyCard.new(@username)
          return self.get_points
      else
          puts "Sorry that name is already taken, please try another."
          return self.create_new_card
      end
    
    # while !check_username(username) 
    # card = LoyaltyCard.new(username)
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

  def self.get_points
    puts "What would you like?"
    puts "1.Small Coffee or 2.Large Coffee"
    option = gets.chomp
    if option == "1"
        target = open("#{@username}.txt", "r+")
        points = target.read.to_i
        points  = points + 5
        target.rewind
        target.write(points)
        puts "Your current points balance is #{points}"
        target.close
    else 
        option == "2"
        target = open("#{@username}.txt", "r+")
        points = target.read.to_i
        points  = points + 10
        target.rewind
        target.write(points)
        puts "Your current points balance is #{points}"
        target.close
    end    
  end
end




def start    
    puts "Hi, good day 😀"
    puts "Do you have a loyaly card with us? "
    puts "1. yes 2. no"
    option = gets.chomp
    if option == "1"
        return LoyaltyCard.access_existing_card
    elsif 
        option == "2"
        return LoyaltyCard.create_new_card 
    else 
        puts "Please key in a valid response"
    end
end    

start
