class Admin::Contest::ContestModuleController < ApplicationController

#  before_filter :authorize_admin
  before_filter :authorize_admin

  def add
    if (request.get?)
      @task = PCS::Model::Task.find(params[:task_id])
      @actions = PCS::Model::ContestModule::ACTIONS
      @program_languages = PCS::Model::ProgramLanguage.find(:all)
    else
      @contest_module = PCS::Model::ContestModule.new(params[:contest_module])
      if (@contest_module.save)
        info("Module action saved succesfully.", "info")
        redirect_message(:controller => "task", :action => "edit",
        :id => params[:id], :task_id => params[:task_id])
      else
      end
    end
  end

  def delete
    PCS::Model::ContestModule.destroy(params[:contest_module_id])
    redirect_to(:controller => "task", :action => "edit",
    :id => params[:id], :task_id => params[:task_id])
  end

end