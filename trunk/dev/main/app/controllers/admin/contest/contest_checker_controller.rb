class Admin::Contest::ContestCheckerController < ApplicationController

#  before_filter :authorize_admin
  before_filter :authorize

  def add
    if (request.get?)
      @task = PCS::Model::Task.find(params[:task_id])
      @actions = PCS::Model::ContestChecker::ACTIONS
      @program_languages = PCS::Model::ProgramLanguage.find(:all)
    else
      @contest_checker = PCS::Model::ContestChecker.new(params[:contest_checker])
      if (@contest_checker.save)
        info("Checker action saved succesfully.", "info")
        redirect_message(:controller => "task", :action => "edit",
        :id => params[:id], :task_id => params[:task_id])
      else
      end
    end
  end

  def delete
    PCS::Model::ContestChecker.destroy(params[:contest_checker_id])
    redirect_to(:controller => "task", :action => "edit",
    :id => params[:id], :task_id => params[:task_id])
  end

end