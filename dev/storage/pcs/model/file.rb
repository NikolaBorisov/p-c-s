require 'soap/rpc/driver'
require 'rubygems'
gem 'activerecord'
require 'active_record'


class PCS::Model::File < ActiveRecord::Base
  set_primary_key "file_id"
  
  has_and_belongs_to_many :articles
  
  has_many :tests_files, :class_name => "PCS::Model::TestFile"
  
  has_many :tests, :through => :tests_files
  
  has_many :modules_files, :class_name => "PCS::Model::ModuleFile"
  
  has_many :modules, :through => :modules_files
  
  has_one :checker
  
  has_one :sample_solution
  
  has_one :submit
  
  def self.save_file(file)
    return nil if (file.size == 0)
    file_record = PCS::Model::File.new
    file_record.name = file.original_filename
    
    if file_record.save
      if(file.instance_of?(StringIO))
        File.open(filename(file_record.file_id), 'w') {|f| f.write(file.read)}
      else
        FileUtils.cp(file.path, filename(file_record.file_id))
      end
      
      # Try to sent to Storage
      # TODO: Reimplement more beautiful. Add retry block
      storage = SOAP::RPC::Driver.new("#{$my_config[:storage][:address]}:#{$my_config[:storage][:port]}", $my_config[:storage][:namespace])
      storage.add_method('add_file', 'file_id', 'user', 'ip', 'source', 'port')
      storage.add_file(file_record.file_id, $my_config[:main][:user], $my_config[:main][:address], path(file_record.file_id) ,$my_config[:main][:port])
      
    end
    
    return file_record
  end
  
  def self.filename(id)
    return File.join("files",id.to_s)
  end
  
  def self.path(id)
    return File.join(FileUtils.pwd, filename(id))
  end
end
