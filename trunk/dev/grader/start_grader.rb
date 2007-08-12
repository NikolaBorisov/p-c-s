require 'pcs/grader/initializer'



PCS::Grader::Initializer.run do |grader, server, storage|
  
  eval(IO.read('config.rb'));
  
  if (ARGV[0])
    server.port = ARGV[0].to_i
  end
  
  if (ARGV[1])
    grader.grader_root = ARGV[1]
  elsif (grader.grader_root.nil?)
    grader.grader_root = File.dirname(File.expand_path(__FILE__))
  end
  
end
