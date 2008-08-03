module PCS


  #
  # A utiliti class. Place here common functions.
  #
  class Utils

    #
    # Returns the filename corresponding to the given file_id.
    #
    def self.fileid2name(file_id)
      return format("file%08d", file_id)
    end

    #
    # Creates directory if it doesn't already exists. If a file with that name exists an
    # exception is raised.
    #
    def self.create_directory(directory)
      if File.exist?(directory)
        if !File.directory?(directory)
          raise "Cannot create #{directory}. File with that name exists"
        end
      else
        Dir.mkdir(directory)
      end
    end

    #
    # Creates a directory on a remote server using ssh and changes to that directory.
    #
    def self.create_remote_directory(server, directory)
      cmd_line = "ssh #{server} mkdir #{directory}"
      result = system(cmd_line)
      cmd_line = "ssh #{server} cd #{directory}"
      result = system cmd_line

      raise "Cannot create #{server}: #{directory}" unless result
    end

    #
    # Clears a directory by removing all of its contents.
    # If the folder has subfolders, they are NOT cleared and deleted.
    #
   def self.clear_directory(directory)
      filelist=Dir.entries(directory)
      filelist.map! { |filename| File.join(directory,filename) }
      FileUtils.rm_f(filelist)
    end

  end



end
