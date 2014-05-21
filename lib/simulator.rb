#need a parent class voter 
#and subclass politician 
#create, list, update, vote 
#all initialization is done by "getsing"
# path = $LOAD_PATH

#hmmmmmm, can I do this in a way that I can make all 
#my methods private
#representaion exposure 
#don't need to reveal details of what's going on 
#behind the scenes 


require '../test/test_simulator.rb'

include SimulatorTests 




class Simulation 
  
  def initialize

  end 
  
  #working 
  def list 
  	#access the array of all objects created 
  	#and replace each full object listing with the object's name 
  	#and party if a politcian or politics if a voter 
    Voter.voters_created.map {|voter| "#{voter.name}, #{voter.class == Politician ? voter.party : voter.politics}"} 
  end

  #working 
  def update
  	puts
  	#weird name so it doesn't match any name in voter list  
  	name = "*%$***"
    #convert to string for search purposes 
    voter_list_as_string = list.join("\n")
  	
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
    index = Voter.voters_created.find_index {|instance| instance.name == name } 
  
  	#find out whether voter is just a voter or a politician as well
 		if ((Voter.voters_created[index].is_a? Voter) && !(Voter.voters_created[index].is_a? Politician))
 			puts
 			puts "New Politics?"
 			prompt
 			new_politics = gets.chomp 
 			#reset voters politics 
 			Voter.voters_created[index].politics = new_politics
 		elsif Voter.voters_created[index].is_a? Politician
 			puts
 			puts "New Party?"
 			prompt
 			new_party = gets.chomp 
 			#rest politicians party 
 			Voter.voters_created[index].party = new_party
 		end

    #reset voter/politicians name 
 		Voter.voters_created[index].name = new_name
  
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
			  new_politician = Politician.new(name,party)
			elsif input == "voter"
				puts "Name?"
			  prompt 
			  name = gets.chomp
			  puts 
			  puts "Politics? Liberal, Conservative, Tea Party, Socialist, or Neutral"
			  prompt 
			  politics = gets.chomp
				new_voter = Voter.new(name,politics)
			end 
    end 
  end

  

  
 
  #working 
  #this method works currently, but I'd like to modify it so that 
  #a voter can only vote once, but waits to meet all candidates before voting 
  
  def vote 
  	#need to separate politcians from voters
  	#the politcian's visiting of a voter is independent 
  	#of the voters voting 

  	voters = Voter.voters_created
    politicians = voters.select {|voter| voter if voter.is_a? Politician}
    
   #  puts
  	# p voters 
  	# puts 
  	# p politicians
  	# puts

  	#can keep track of the votes for each candidate 
  	#with inject or in a hash 
    
  	vote_count = Hash.new(0)


    
  	#how does a voter actually vote 
  	#in this model, they are not presented with an array
  	#of options and told to choose one 
  	#it seems as if they are able to vote for
  	#as many candiadates as they like
  	#but the likelihood is based on probablity 

  	#but to ensure a winner
  	#I need to restrict it to one voter one vote 
    
  	#each politicians visits each voter and every other politician
  	#including themselves 

  	campaign_stops = politicians.product(voters)
  	# p campaign_stops
     
   
    #campaign/voting 
  	campaign_stops.each do |person|

      campaigner = person[0]
      campaignee = person[1]

      if (campaigner.is_a? Politician) && ((campaignee.is_a? Voter)  && !(campaignee.is_a? Politician))
        #&& (campaignee.voted == false) removed from conditional above
        #only allows a voter to vote once, but before meeting all candidates

      	puts <<-STUMPSPEECH
        Howdy there constituent #{campaignee.name}!
        You are #{campaignee.politics}.
        I'm #{campaigner.name}, and I'm a #{campaigner.party}.
        Can I count on your vote?

      	STUMPSPEECH
      	
      	if campaignee.cast_vote(campaigner)
      			vote_count[campaigner.name] += 1
      			campaignee.voted = true
      	end

      	p vote_count
      end
    end 


        #if some_method == true 

      	# if (campaigner.party == "Democrat") #&& (campaignee.politics == "Progressive" || campaignee.politics == "Liberal" )
      	# 	if campaignee.cast_vote(campaigner)
      	# 		vote_count[campaigner.name] += 1
      	# 		campaignee.voted = true
      	# 	end
      	# elsif (campaigner.party == "Republican") #&& (campaignee.politics == "Conservative" || campaignee.politics == "Nativist" )
      	# 	if campaignee.cast_vote(campaigner)
      	# 		vote_count[campaigner.name] += 1
      	# 		campaignee.voted = true
      	# 	end
      	# end 

    #   elsif (campaigner.is_a? Politician) && (campaignee.is_a? Politician)
    #   		if campaigner == campaignee
    #   			vote_count[campaigner.name] += 1
    #   			campaignee.voted = true
    #   		elsif ((campaigner != campaignee) && (campaigner.party == campaignee.party))
      			
  		# 	puts <<-BRUSHOFF
  		# 	Howdy there #{campaignee.name}!
  		# 	You are a fellow member of the #{campaigner.party} party!
  		# 	Though I largely agree with you on all issues,
  		# 	I will latch on to a trivial distinction in 
  		# 	our policy stances to justify opposing and villifying you.
  		# 	If you should, however, win this election, 
  		# 	please consider me for an appointment to high office.

  		# 	BRUSHOFF
   	# 			elsif ((campaigner != campaignee) && (campaigner.party != campaignee.party))
				
				# puts <<-DENNUNCIATION
  		# 	#{campaigner.name}! You vile #{campaigner.party}!
  		# 	How can you dream of aspiring to higher office 
  		# 	in this great land of ours?
  		# 	You most certainly eat babies and torture puppies!
  		# 	Fie on you and your political aspirations.
  		# 	I shall crush you in the present electoral contest!

  		# 	DENNUNCIATION
    #   		end #campaigner == campaignee
    #   end #(campaigner.is_a? Politician) && ((campaignee.is_a? Voter) && !(campaignee.is_a? Politician))
    #end #(campaigner.is_a? Politician) && ((campaignee.is_a? Voter) && !(campaignee.is_a? Politician))

    # puts 
    # p vote_count

  	#at the time of the visit, the visitee casts a vote based 
  	#on the probability that somone with their politics 
  	#will vote for someone of the politician's party
    

  	#if the voter has already voted for someone, they listen to the politican 
  	#but say sorry I've already voted 
  	#if the voter is another politcian, they denounce the politcian 
  	#if the politician is 

  end 
  
  ###############helpers##############
  def prompt 
  	print "> "
  end

  #####################################


end

#so a key attribute of voters is that they vote
# politicians vote and campaign 
#
  

class Voter
  
  attr_accessor :name, :politics, :voted
	#@@? to keep track of voters_created created ? 
  @@list = []
  @@voters_created = []

	def initialize(name,politics)
		@name = name 
		@politics = politics 
    @voted = false 

    @@list << "#{@name}, #{@politics}"
    @@voters_created << self

	end 

	def self.voters_created
		@@voters_created
  end


  # need to randomly pick a number not included in the rand
  def cast_vote(politician)
  	if ((self.is_a? Voter) && !(self.is_a? Politician))
  		if politician.party == "Democrat"
  	    if ((self.politics == "Socialist") && ((1..90).include? rand(100) + 1))
  	    	return true
  			end
  			if ((self.politics == "Liberal") && ((1..75).include? rand(100) + 1))
  	    	return true
  			end
  			if ((self.politics == "Neutral") && ((1..50).include? rand(100) + 1))
  	    	return true
  			end
  			if ((self.politics == "Conservative") && ((1..25).include? rand(100) + 1))
  	    	return true
  			end
  			if ((self.politics == "Tea Party") && ((1..10).include? rand(100)+ 1))
  	    	return true
  			end
  		elsif politician.party == "Republican"
  			if ((self.politics == "Tea Party") && ((1..90).include? rand(100) + 1))
  	    	return true
  			end
  			if ((self.politics == "Conservative") && ((1..75).include? rand(100) + 1))
  	    	return true
  			end
  			if ((self.politics == "Neutral") && ((1..50).include? rand(100) + 1))
  	    	return true
  			end
  			if ((self.politics == "Liberal") && ((1..25).include? rand(100) + 1))
  	    	return true
  			end
  			if ((self.politics == "Socialist") && ((1..10).include? rand(100)+ 1))
  	    	return true
  			end
  		end     
  	elsif ((self.is_a? Voter) && (self.is_a? Politician))
  		if self == politician
  			return true 
  		end 
  	end
  end	
end  



class Politician < Voter

	attr_accessor :party
	
	def initialize(name,party) 
		@name = name 
  	@party = party
  	@voted = false 
  	@@list << "#{@name}, #{@party}"
  	@@voters_created << self

	end 

end 


 




   

		def main_menu


		end 


		def create

		end 

		def list 


		end 

		def update 

		end 

		def vote 


		end 

		def campaign 

		end  

		def stump_speech 

		end 

#test_list
#test_create
#test_update
test_vote 


