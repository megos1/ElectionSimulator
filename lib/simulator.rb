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
    # Voter.voters_created.map {|voter| Array.new(2,"#{voter.name}","#{voter.class == Politician ? voter.party : voter.politics}")} 
    # Voter.voters_created.map {|voter| ["hello"], ["goodbye"] }
  end

  #testing 
  def update
  	puts
  	name = ""

    list_as_string = list.join("\n")
  	

  	until list_as_string =~ /name/
      puts "Name?" 
      name = gets.chomp 
 		  prompt
 		end 

 		puts "New name?"
 		prompt	
 		new_name = gets.chomp 

    #conditional 
    #need to search the array of objects 
    #to see if the object with the name new_name 
    #is a voter or politician 

    #if a voter update in one way 
    #if a politician update in a different way 

    index = Voter.voters_created.find_index {|instance| instance.name == name } 
  
 		if Voter.voters_created[index].is_a? Voter
 			puts
 			puts "New Politics?"
 			prompt
 			new_politics = gets.chomp 
 			Voter.voters_created[index].politics = new_politics
 		elsif Voter.voters_created[index].is_a? Politician
 			puts
 			puts "New Party?"
 			prompt
 			Voter.voters_created[index].party = new_party
 		end

    #save this step for last 
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

      if (campaigner.is_a? Politician) && ((campaignee.is_a? Voter) && (campaignee.voted == false) && !(campaignee.is_a? Politician))
      	
      	puts <<-STUMPSPEECH
        Howdy there constituent #{campaignee.name}!
        You are #{campaignee.politics}.
        I'm #{campaigner.name}, and I'm a #{campaigner.party}.
        Can I count on your vote?

      	STUMPSPEECH
      	#nested conditional
      	if (campaigner.party == "Democrat") && (campaignee.politics == "Progressive" || campaignee.politics == "Liberal" )
      		vote_count[campaigner.name] += 1
      		campaignee.voted = true
      	elsif (campaigner.party == "Republican") && (campaignee.politics == "Conservative" || campaignee.politics == "Nativist" )
      		vote_count[campaigner.name] += 1
      		campaignee.voted = true
      	end 

      elsif (campaigner.is_a? Politician) && (campaignee.is_a? Politician)
      		if campaigner == campaignee
      			vote_count[campaigner.name] += 1
      			campaignee.voted = true
      		elsif ((campaigner != campaignee) && (campaigner.party == campaignee.party))
      			
  			puts <<-BRUSHOFF
  			Howdy there #{campaignee.name}!
  			You are a fellow member of the #{campaigner.party} party!
  			Though I largely agree with you on all issues,
  			I will latch on to a trivial distinction in 
  			our policy stances to justify opposing and villifying you.
  			If you should, however, win this election, 
  			please consider me for an appointment to high office.

  			BRUSHOFF
   				elsif ((campaigner != campaignee) && (campaigner.party != campaignee.party))
				
				puts <<-DENNUNCIATION
  			#{campaigner.name}! You vile #{campaigner.party}!
  			How can you dream of aspiring to higher office 
  			in this great land of ours?
  			You most certainly eat babies and torture puppies!
  			Fie on you and your political aspirations.
  			I shall crush you in the present electoral contest!

  			DENNUNCIATION
      		end #campaigner == campaignee
      end #(campaigner.is_a? Politician) && ((campaignee.is_a? Voter) && !(campaignee.is_a? Politician))
    end #(campaigner.is_a? Politician) && ((campaignee.is_a? Voter) && !(campaignee.is_a? Politician))

    puts 
    p vote_count

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


