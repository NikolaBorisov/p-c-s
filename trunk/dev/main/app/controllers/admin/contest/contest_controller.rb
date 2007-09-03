class Admin::Contest::ContestController < ApplicationController

#  before_filter :authorize_admin
  before_filter :authorize

  def index
    redirect_to(:action => :list)
  end

  def list
    @contests = PCS::Model::Contest.find(:all)
  end

  def create
    if (request.post?)
      @contest = PCS::Model::Contest.new(params[:contest])

      @contest.duration = @contest.end_time - @contest.start_time
      @contest.owner_id = session[:user_id]
      @contest.is_private = true
      if (@contest.save)
        info("Contest Created Succesfully.", "info")
        redirect_message(:action => "list")
      else
      end
    else
    end

    @contest_types = PCS::Model::ContestType.find(:all)
    @board_types = PCS::Model::BoardType.find(:all)
  end

  def edit
    if (request.post?)
      #TODO: Check if update is save
      @contest = PCS::Model::Contest.update(params[:id], params[:contest])

      @contest.duration = @contest.end_time - @contest.start_time
      @contest.owner_id = session[:user_id]
      @contest.is_private = true

      if ( @contest.save )
        info("Contest saved successfully.", "info")
        redirect_message(:action => "list")
      else
      end
    else
      @contest = PCS::Model::Contest.find(params[:id])
      @contest_types = PCS::Model::ContestType.find(:all)
      @board_types = PCS::Model::BoardType.find(:all)
    end
  end

  def delete
    PCS::Model::Contest.destroy(params[:id])

    info("Contest deleted succesfully.")
    redirect_message(:action => "list")
  end

end
