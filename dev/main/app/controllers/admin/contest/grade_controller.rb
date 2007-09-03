class Admin::Contest::GradeController < ApplicationController

#  before_filter :authorize_admin
  before_filter :authorize

  def index
    @contest = PCS::Model::Contest.find(params[:id])
  end

  def grade_all
    submits = PCS::Model::Submit.find(:all, :conditions => ["contest_id = ?", params[:id]])
    grader_response_ids = []
    submits.each do |submit|
      grader_response_ids << send_grade(submit.contest_id, submit.task_id, submit.submit_id)
    end
    redirect_to(:action => :view_grading_queue, :ids => grader_response_ids)
  end

  def view_grading_queue
    @grader_responses = PCS::Model::GraderResponse.find(params[:ids])
  end

  def view_results
    @users = PCS::Model::Users.find(:all,
                                    :joins => "INNER JOIN contests_privileges c ON constest.user_id = users.user_id",
    :contitions => ["c.contest_id = ? and c.competed = 1)", params[:id]])
    @contest = PCS::Model::Contest.find(params[:id])
    @tasks = @contest.tasks

  end
end