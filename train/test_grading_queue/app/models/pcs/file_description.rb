module PCS
  
  
  
  class FileDescription
    INPUT = 1
    SOLUTION = 2
    SOURCE = 3
    MODULE = 4
    HEADER = 5
    CHECKER = 6
    OUTPUT = 7
    
    FileTypeOptions = [ ['INPUT', INPUT], ['SOLUTION', SOLUTION],
                        ['SOURCE', SOURCE], ['MODULE', MODULE],
                        ['HEADER', HEADER], ['CHECKER', CHECKER],
                        ['OUTPUT', OUTPUT] ]
    
    attr_accessor :name, :file_id, :type
    
    def initialize(name, file_id, type)
      @name = name
      @file_id = file_id
      @type = type
    end
  end
  
  
  
end