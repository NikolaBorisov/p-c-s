include PCS::WEB::TASK_CONTROLLER_SUPPORT

class Admin::Task::CheckerController < ApplicationController
  #before_filter :authorize_admin
  before_filter :authorize

  def edit()
    task = valid_task( params[:id] )
    redirect_to_index("Invalid task") and return unless( task )

    @checker = valid_checker( params[:checker_id] )
    @checker = PCS::Model::Checker.new() unless( @checker )

    if( request.get? )
      @program_languages = PCS::Model::ProgramLanguage.find(:all, :order => "name").map{ |plang| [plang.name, plang.id] }
    else
      @checker.name = params[:checker][:name]
      @checker.program_language = PCS::Model::ProgramLanguage.find( params[:checker][:program_language_id] )
      @checker.task = task

      file = PCS::Model::File.save_file( params[:file] )

      if( file )
        old_file_id = @checker.file.id if( @checker.file )
        @checker.file = file
        #PCS::Model::File.find( old_file_id ).destroy() if( old_file_id )
      end

      @checker.save()
      PCS::Model::File.find( old_file_id ).destroy() if( old_file_id )
      redirect_to_task("Checker successfully added", task.id, 3)
    end

  end

  def delete()
    checker = valid_checker( params[:id] )
    redirect_to_index("Invalid checker") and return unless( checker )
    task_id = checker.task.id

    checker.destroy()

    redirect_to_task("Checker deleted", task_id, 3)
  end

end
