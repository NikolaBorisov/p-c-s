module PCS
  
  
  
  class CompilerOption
    
    SOURCE_PATTERN = '#SOURCES#'
    DESTINATION_PATTERN = '#DESTINATION#'
    INCLUDE_PATH_PATTERN = '#INCLUDE_PATH#'
    
    attr_accessor :command_line, :time_limit
    
  end
  
  
  
end