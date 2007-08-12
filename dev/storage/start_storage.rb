require 'pcs/storage/initializer'



PCS::Storage::Initializer.run do |storage, server|
  
  eval(IO.read('config.rb'));
  
  if (ARGV[0])
    server.port = ARGV[0].to_i
  end
  
  if (ARGV[1])
    storage.storage_root = ARGV[1]
  elsif (storage.storage_root.nil?)
    storage.storage_root = File.dirname(File.expand_path(__FILE__))
  end
  
end
