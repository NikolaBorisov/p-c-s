require 'pcs/grading_queue/initializer'



PCS::GradingQueue::Initializer.run do |queue, server|
  
  eval(IO.read('config.rb'));
  
  if (ARGV[0])
    server.port = ARGV[0].to_i
  end
  
  if (ARGV[1])
    queue.grading_queue_root = ARGV[1]
  elsif (queue.grading_queue_root.nil?)
    queue.grading_queue_root = File.dirname(File.expand_path(__FILE__))
  end
  
end
