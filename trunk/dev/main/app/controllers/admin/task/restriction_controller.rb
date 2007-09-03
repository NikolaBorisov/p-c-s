include PCS::WEB::TASK_CONTROLLER_SUPPORT

class Admin::Task::RestrictionController < ApplicationController
#  before_filter :authorize_admin
  before_filter :authorize

  def edit()
    task = valid_task( params[:id] )
    redirect_to_index("Invalid Task") and return unless( task )

    @restriction = valid_restriction( params[:restriction_id ] )
    @restriction = PCS::Model::Restriction.new() unless( @restriction )

    if( request.get? )

    else
      @restriction.runtime = params[:restriction][:runtime]
      @restriction.memory = params[:restriction][:memory]
      @restriction.stack_size = params[:restriction][:stack_size]
      @restriction.source_code = params[:restriction][:source_code]
      @restriction.output_size = params[:restriction][:output_size]
      @restriction.compilation_time = params[:restriction][:compilation_time]
      @restriction.task = task;
      @restriction.save()

      redirect_to_task("Restriction saved", task.id, 5)
    end

  end

  def delete()
    restriction = valid_restriction( params[:id ] )
    redirect_to_index("Invalid restriction") and return unless( restriction )
    task_id = restriction.task_id

    restriction.destroy();

    redirect_to_task("Restrictio deleted", task_id, 5)
  end

end
