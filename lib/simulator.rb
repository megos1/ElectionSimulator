require 'pp'
require '../test/test_simulator.rb'

include SimulatorTests 


class Simulation 
  
  def initialize
    main_menu
  end 

  private 

  def main_menu
    
    voters = Voter.voters_created
    politicians = voters.select {|voter| voter if voter.is_a? Politician}

    puts
    puts "What would you like to do? Create, List, Update, or Vote?"
    prompt 
    action = gets.chomp.downcase 
    
    #flawed, need to correct
    while true 
      if action == "vote" 
        #&& voters.length >= 3 && politicians.length < voters.length
        vote 
      elsif action == "create"
        create
      elsif action == "list"
        list 
      elsif action == "update"
        update
      end
    end 
  end 

  #working 
  def create
    puts 
    input = ""
    until input == "politician" || input == "voter"
      puts "What would you like to create? Politician or Voter?"
      input = gets.chomp.downcase

      if input == "politician"
        puts "Name?"
        prompt 
        name = gets.chomp
        puts 
        puts "Party? Democrat or Republican"
        prompt 
        party = gets.chomp
        Politician.new(name,party)
      elsif input == "voter"
        puts "Name?"
        prompt 
        name = gets.chomp
        puts 
        puts "Politics? Liberal, Conservative, Tea Party, Socialist, or Neutral"
        prompt 
        politics = gets.chomp
        Voter.new(name,politics)
      end 
    end 
    main_menu
  end

  #working 
  def list 
  	#access the array of all objects created 
  	#and replace each full object listing with the object's name 
  	#and party if a politcian or politics if a voter 
    puts
    puts Voter.voters_created.map {|voter| "#{voter.name}, #{voter.class == Politician ? voter.party : voter.politics}"} 
    main_menu
  end

  #working 
  def update
  	puts
  	#weird name so it doesn't match any name in voter list  
  	name = "*%$***"
    voter_list = Voter.voters_created.map {|voter| "#{voter.name}, #{voter.class == Politician ? voter.party : voter.politics}"} 
    #convert to string for search purposes 
    voter_list_as_string = voter_list.join("\n")
  	voter_list_as_objects = Voter.voters_created
  	#compare user input against existing list of voters
  	until voter_list_as_string.include? name
      puts "Name?" 
      prompt
      name = gets.chomp  
 		end 
    #get new name 
 		puts
 		puts "New name?"
 		prompt	
 		new_name = gets.chomp  
    
    #find index at which given voter name occurs, so we access that voter object below 
    index = voter_list_as_objects.find_index {|instance| instance.name == name } 
  
  	#find out whether voter is just a voter or a politician as well
 		if ((voter_list_as_objects[index].is_a? Voter) && !(voter_list_as_objects[index].is_a? Politician))
 			puts
 			puts "New Politics?"
 			prompt
 			new_politics = gets.chomp 
 			#reset voters politics 
 			voter_list_as_objects[index].politics = new_politics
 		elsif voter_list_as_objects[index].is_a? Politician
 			puts
 			puts "New Party?"
 			prompt
 			new_party = gets.chomp 
 			#rest politicians party 
 			voter_list_as_objects[index].party = new_party
 		end

    #reset voter/politicians name 
 		voter_list_as_objects[index].name = new_name
    
    main_menu
  end

  #kind of working but needs imporvement   
  def vote 
  	
    voters = Voter.voters_created
   
    politicians = Voter.voters_created.select {|voter| voter if voter.is_a? Politician}
    vote_count = Hash.new(0)
    who_voted_for_whom = Hash.new(0)
    #introduce an element of fairness by varying when candidates get to visit voters 
    campaign_stops = politicians.product(voters).shuffle

    campaign_stops.each do |stump_speech|
      campaigner = stump_speech[0]
      campaignee = stump_speech[1]

      campaigner.stump(campaignee)
       
      #need way to cancel out votes 

      if campaignee.cast_vote(campaigner)
        puts "\tYou bet!"
        vote_count[campaigner.name] += 1
        who_voted_for_whom[campaignee.name] = campaigner.name
        puts
      elsif campaignee.voted == true 
        puts "\tSorry, I've already voted"
        puts
      elsif campaignee.cast_vote(campaigner) && (campaigner == campaignee)
        puts "\tI am #{campaigner.name}, and I am voting for myself!"
        vote_count[campaigner.name] += 1 
        who_voted_for_whom[campaignee.name] = campaigner.name
        puts
      elsif  ( !campaignee.cast_vote(campaigner) ) &&  ( !campaignee.is_a? Politician )
        puts "\tI am not persuded by your logic"
        puts
      end 
    end 

    sorted_vote_count = vote_count.to_a.sort {|a,b| b[1] <=> a[1]}
    puts
    puts
    puts "\t\tWINNER"
    puts "\tAnd the winner is #{sorted_vote_count[0][0]}!"
    puts "\t\tWINNER"
    puts
    puts "\tAnd because this is a transparent democracy, here's the vote totals:"
    puts 
    puts "\t#{vote_count}"
    puts
    puts "\tAnd let's see who voted for whom so we can purge the disloyal."
    puts
    puts "\t#{who_voted_for_whom}"

    Process.exit
  end
    
  	
    
  ###############helpers##############
  def prompt 
  	print "> "
  end

  #####################################


end


class Voter
  
  attr_accessor :name, :politics, :voted
	#@@? to keep track of voters_created created ? 
  @@voters_created = []

	def initialize(name,politics)
		@name = name 
		@politics = politics 
    @voted = false 
    @@voters_created << self

	end 

	def self.voters_created
		@@voters_created
  end


  # need to randomly pick a number not included in the rand
  def cast_vote(politician)
  	if ((self.is_a? Voter) && !(self.is_a? Politician) && (self.voted == false))
  		if politician.party == "Democrat"
  	    if ((self.politics == "Socialist") && ((1..90).include? rand(100) + 1))
          self.voted = true
          return true
  			end
  			if ((self.politics == "Liberal") && ((1..75).include? rand(100) + 1))
          self.voted = true
          return true
  			end
  			if ((self.politics == "Neutral") && ((1..50).include? rand(100) + 1))  	
          self.voted = true
          return true
  			end
  			if ((self.politics == "Conservative") && ((1..25).include? rand(100) + 1))
          self.voted = true
          return true
  			end
  			if ((self.politics == "Tea Party") && ((1..10).include? rand(100)+ 1))
          self.voted = true
          return true
  			end
  		elsif politician.party == "Republican"
  			if ((self.politics == "Tea Party") && ((1..90).include? rand(100) + 1))
           self.voted = true
           return true
  			end
  			if ((self.politics == "Conservative") && ((1..75).include? rand(100) + 1))
          self.voted = true
          return true
  			end
  			if ((self.politics == "Neutral") && ((1..50).include? rand(100) + 1))
          self.voted = true
          return true
  			end
  			if ((self.politics == "Liberal") && ((1..25).include? rand(100) + 1))
          self.voted = true
          return true
  			end
  			if ((self.politics == "Socialist") && ((1..10).include? rand(100)+ 1))
          self.voted = true
          return true
  			end
  		end     
  	elsif ((self.is_a? Voter) && (self.is_a? Politician))
  		if self == politician
        self.voted = true
  			return true 
  		end 
    else 
      return false
    end
  end	
end  



class Politician < Voter

	attr_accessor :party
	
	def initialize(name,party) 
		@name = name 
  	@party = party
  	@voted = false 
  	@@voters_created << self

	end

  def stump(voter)
    
    if (self.is_a? Politician) && ((voter.is_a? Voter)  && !(voter.is_a? Politician))
        #&& (campaignee.voted == false) removed from conditional above
        #only allows a voter to vote once, but before meeting all candidates
        puts <<-STUMPSPEECH
        Howdy there constituent #{voter.name}!
        You are #{voter.politics}.
        I'm #{self.name}, and I'm a #{self.party}.
        Can I count on your vote?

        STUMPSPEECH
    elsif (self.is_a? Politician) && (voter.is_a? Politician) && (self.party == voter.party) && (self != voter)
        puts <<-BRUSHOFF
        Howdy there #{voter.name}!
        I'm #{self.name}, a #{self.party}.
        You are a fellow member of the #{self.party} party!
        Though I largely agree with you on all issues,
        I will latch on to a trivial distinction in 
        our policy stances to justify opposing and villifying you.
        If you should, however, win this election, 
        please consider me for an appointment to high office.

        BRUSHOFF
    elsif (self.is_a? Politician) && (voter.is_a? Politician) && (self.party != voter.party)
        puts <<-DENNUNCIATION
        #{self.name}! You vile #{self.party}!
        How can you dream of aspiring to higher office 
        in this great land of ours?
        You most certainly eat babies and torture puppies!
        Fie on you and your political aspirations.
        I, #{voter.name} shall crush you in the present electoral contest!

        DENNUNCIATION
    end #(campaigner.is_a? Politician) && ((campaignee.is_a? Voter) && !(campaignee.is_a? Politician))
  end #campaign 
end 


 
#test_list
#test_create
#test_update
#test_vote 
#test_main_menu
Simulation.new

