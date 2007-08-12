class Contestant::ContestController < ApplicationController
  
  before_filter :authorize
  
  def list
    @allowed_contests = PCS::Model::Contest.find(:all)
  end
  
  def index
    if (params[:id].nil?)
      redirect_to(:action => "list")
    end
    @contest = PCS::Model::Contest.find(params[:id])
  end
  
  def enter
  end
  
  def show_task
    @task = PCS::Model::Task.find(params[:task_id])
    @restriction = PCS::Model::ContestTask.find(:first, :conditions => ["contest_id = ? AND task_id = ?", params[:id], params[:task_id]]).restriction
    @content_text = "";
    if (params[:language_id])
      @content = PCS::Model::TaskContent.find(:first,
                                                  :conditions => ["task_id = ? AND language_id = ?", params[:task_id], params[:language_id]])
      @content_text = @content.content
    end
  end
  
  def list_tasks
    @contest = PCS::Model::Contest.find(params[:id])
  end
  
  def submit
    @contest = PCS::Model::Contest.find(params[:id])
  end
  
  def list_submits
    # Selects all submits for this user, and contest
    @submits = PCS::Model::Submit.find(:all,
                                       :conditions => ["user_id = ? AND contest_id = ?",
                                       session[:user_id],
                                       params[:id]])
  end
  
  def list_submit_responses
    @grader_responses = PCS::Model::GraderResponse.find(:all,
                                                        :conditions => ["submit_id = ?", params[:submit_id]])
  end
  
  def process_submit
    file = PCS::Model::File.save_file(params["submit"]["file"])    
    submit = PCS::Model::Submit.new
    submit.user_id = session[:user_id]
    submit.task_id = params["submit"]["task_id"]
    submit.contest_id = params[:id]
    submit.file = file
    submit.program_language_id = params["submit"]["program_language_id"]
    submit.submit_at = Time.now
    if (submit.save)
      send_submit(params[:id], params["submit"]["task_id"], submit.id)
      info("Submission send succesfully.", "info")
      redirect_message(:action => "index", :id => params[:id])
    else
      info("Error occured, while submitting","error")
      redirect_message(:action => "submit", :id => params[:id])
    end
  end
  
  private
  
  
end
