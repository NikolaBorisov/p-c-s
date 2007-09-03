include PCS::WEB::TASK_CONTROLLER_SUPPORT

class Admin::Task::ModuleController < ApplicationController
#  before_filter :authorize_admin
  before_filter :authorize

  def edit()
    task = valid_task( params[:id] )
    @mod = valid_module( params[:module_id] )

    if( request.get? )

    else

      @mod = PCS::Model::Module.new() unless( @mod )

      @mod.name = params[:mod][:name]
      @mod.task = task
      @mod.save()


      file_module = ( params[:file_module] ) ? PCS::Model::File.save_file( params[:file_module] )  : nil
      file_header = ( params[:file_header] ) ? PCS::Model::File.save_file( params[:file_header] )  : nil

      if( file_module )
        module_file = PCS::Model::ModuleFile.new()
        module_file.file = file_module
        module_file.module_type = PCS::FileDescription::MODULE
        module_file.modul = @mod
        module_file.save()
      end

      if( file_header )
        module_file = PCS::Model::ModuleFile.new()
        module_file.file = file_header
        module_file.module_type = PCS::FileDescription::HEADER
        module_file.modul = @mod
        module_file.save()
      end


      redirect_to_task( "Module saved", task.id, 2 )
    end

  end

  def delete()
    #:id => which module to delete
    #:module_file_id => which module_file(if nil, all modules_files) of the module to delete

    mod = valid_module( params[:id] )
    redirect_to_index("Invalid module") and return unless( mod )

    task_id = mod.task.id

    module_file_id = params[:module_file_id]

    unless( module_file_id )
      mod.destroy() # destroy the whole module and all its files
    else
      #TODO: Handel invalid module_file_id
      module_file = mod.modules_files.find( :first,
                                           :conditions => ["module_file_id = ?", module_file_id ] )
      module_file.destroy() if( module_file )
    end

    redirect_to_task("Module file(s) deleted", task_id, 2)
  end

end
