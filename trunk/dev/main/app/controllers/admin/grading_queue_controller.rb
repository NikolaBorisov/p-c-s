class Admin::GradingQueueController < ApplicationController

# FIXME: after 0.1
#  before_filter :authorize_admin

  def index
    list_graders
  end

  def start
    # FIXME: Implement post 0.1
  end

  def stop
    # FIXME: Implement post 0.1
  end

  def restart
    # FIXME: Implement post 0.1
  end

  # FIXME: This method needs improvements. Should do something to test the connection to the grader.
  # A change in the Grader, and GradingQueue is also required.
  def add_grader
    if (request.post?)
      if (params[:grader][:address]!=nil and params[:grader][:port].to_i>0)
        connect()
        id = @gq.add_grader(params[:grader][:address],params[:grader][:port])
        info("Grader was successfully added. with id #{id}", "info")
        redirect_message(:action => 'index')
      else
        info("Error","error")
        redirect_message(:action => 'add_grader')
      end
    end
  end

  def delete_grader
    grader_id = params[:id].to_i
    connect()
    @gq.delete_grader(grader_id)
    info("Grader with id #{grader_id} was deleted.", "info")
    redirect_message(:action => 'index')
  end

  def list_graders
    connect()
    @graders_ids = @gq.get_graders
    @graders_ids.sort!
  end

  private

  def connect
    @gq = SOAP::RPC::Driver.new("#{$my_config[:grading_queue][:address]}:#{$my_config[:grading_queue][:port]}", $my_config[:grading_queue][:namespace])
    @gq.add_method('add_grader', 'grader_address', 'grader_port')
    @gq.add_method('get_graders')
    @gq.add_method('delete_grader', 'grader_id')
  end

end
