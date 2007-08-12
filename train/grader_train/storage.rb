require "compiler.rb"

class Storage

  def self.get_problem(problem_id)
    h = Hash.new
    h[:problem_name] = "test_task"
    h[:type] = 1
    h[:time_limit] = 2500     #MiliSecond
    h[:memory_limit] = 10        #MB
    h[:output_limit] = 2000   #KB
    h
  end
  
  def self.copy_solution_to(submit_id, module_id, destination)
    language = "C"
    source = ["./tmp/slow.c", ]
    options = ["-static","-O2"]
    
    Compiler.compile(language, source, destination, options, 3)    
  end

  def self.copy_test_to(test_id, destination)
  end
  
end

#Storage.copy_solution_to("a","b","c")