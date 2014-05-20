class Voter
  @@list = ["Matt, Communist"]
  @@id = 0 
  attr_accessor :list 

  def initialize(name,politics) 
  	@name = name 
  	@politics = politics
  	@@list << "#{@name}, #{@politics}"


  end 


end 

def show_class_var
  puts Voter.class_eval('@@list')
end 


show_class_var
my_voter = Voter.new("Jay", "Facist")
show_class_var



