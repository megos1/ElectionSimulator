module SimulatorTests 


	def test_list 
		puts "New Simulation"
		puts
		my_simulation = Simulation.new
		puts "Create Politician Joe Bidden, Democrat"
		puts 
		joe_bidden = Politician.new("Joe Bidden", "Democrat")
		puts "Create Voter Lucky Luciano, Socialist"
		puts
		lucky_luciano = Voter.new("Luck Luciano", "Socialist")
		puts "Let's see the list of all people"
    puts my_simulation.list
	end 



	def test_create 
   

    my_simulation = Simulation.new

  
		puts
		my_simulation.create
		puts
		my_simulation.list 
    puts
		my_simulation.create
		puts
		my_simulation.list
		puts
		my_simulation.create
		puts
		my_simulation.list
	end 

	def test_update

		my_simulation = Simulation.new
		Voter.new("Joe Smith", "Liberal")
		Voter.new("Mike Suarez", "Conservative")
		Voter.new("Lorenzo Gamio", "Progressive")
		Politician.new("Joe Garcia", "Republican")
		Politician.new("Elaine Kagan", "Democrat")
		Politician.new("Mike Koch", "Republican")


		
 		
 		puts
    puts "Lets see all our Voters in list format"
    puts my_simulation.list
    puts
		# puts "Now as an array of objects"
		# p Voter.voters_created
		my_simulation.update
		puts
		puts my_simulation.list
		puts
		my_simulation.update
		puts
		puts my_simulation.list


	end

	def test_vote
		my_simulation = Simulation.new
		Voter.new("Joe Smith", "Liberal")
		Voter.new("Mike Suarez", "Conservative")
		Voter.new("Lorenzo Gamio", "Progressive")
		Voter.new("Ed Toro", "Nativist")
		Politician.new("Joe Garcia", "Republican")
		Politician.new("Elaine Kagan", "Democrat")
  	Politician.new("Mike Koch", "Republican")
    my_simulation.vote 


	end 

end 
