class Admin::Contest::TaskController < ApplicationController

#  before_filter :authorize_admin
  before_filter :authorize

  def list
    @contest = PCS::Model::Contest.find(params[:id])
  end

  def add
    @tasks = PCS::Model::Task.find(:all)
    if (request.get?)

    else
      restriction = PCS::Model::Restriction.find(:first, :conditions => ["task_id = ?", params[:contest_task][:task_id] ])
      if (restriction.nil?)
        info("This task has no restrictions defined and can NOT be added to contest.", "error")
        render(:action => "add")
        return
      end
      params[:contest_task][:restriction_id] = restriction.id
      @contest_task = PCS::Model::ContestTask.new(params[:contest_task])
      if (restriction && @contest_task.save)
        info("Task succesfully added to contest.", "info")
        redirect_message(:action => "list", :id => @contest_task.contest_id)
      else
      end
    end
  end

  def edit
    @contests_modules = PCS::Model::ContestModule.find(:all,
                                                       :conditions => ["contest_id = ? AND task_id = ?", params[:id], params[:task_id]])
    @contests_checkers = PCS::Model::ContestChecker.find(:all,
                                                         :conditions => ["contest_id = ? AND task_id = ?", params[:id], params[:task_id]])
    @contest_task = PCS::Model::ContestTask.find(:first,
                                                 :conditions => ["contest_id = ? AND task_id = ?", params[:id], params[:task_id]])
    @task = PCS::Model::Task.find(params[:task_id])
    @actions = PCS::Model::ContestModule::ACTIONS
  end

  def change_restriction
    contest_task = PCS::Model::ContestTask.find(:first, :conditions => ["contest_id = ? AND task_id = ?", params[:id], params[:task_id]])
    contest_task.restriction_id = params[:contest_task][:restriction_id]
    if (contest_task.save)
      info("Restriction changed.", "info")
      redirect_message(:action => "edit", :id => params[:id], :task_id => params[:task_id] )
    else
      info("Failed to change restriction.", "error")
      render(:action => "edit")
    end
  end

  def delete
    contest_task = PCS::Model::ContestTask.destroy(params[:contest_task_id])
    redirect_to(:action => "list", :id => params[:id])
  end

end