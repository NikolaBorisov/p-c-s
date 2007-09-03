include PCS::WEB::TASK_CONTROLLER_SUPPORT

class Admin::Task::PrivilegesController < ApplicationController
  # before_filter :authorize_admin
  before_filter :authorize

  def add()
    task = valid_task( params[:id] )
    user = valid_user( params[:user_id] )
    redirect_to_index("Invalid data") unless( task || user)

    user.tasks << task

    redirect_to_task("Privileges Added", params[:id], 6)
  end

  def delete()
    task = valid_task( params[:id] )
    user = valid_user( params[:user_id] )
    redirect_to_index("Invalid data") and return unless( task || user)

    redirect_to_task("Can't delete owner", params[:id], 6) and return if( task.owner==user )

    task.privileged_users.delete( user )

    redirect_to_task("Privileges Deleted", params[:id], 6)
  end

end
