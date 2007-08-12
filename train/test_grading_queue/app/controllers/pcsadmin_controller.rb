#require 'grader_response.rb'

class PcsadminController < ApplicationController
  
  def index
  end
  
  def add_grader
  end
  
  def create_grader
    if params[:grader][:address]!=nil and params[:grader][:port].to_i>0
      @gq = SOAP::RPC::Driver.new('http://judge.openfmi.net:5004', 'urn:PCS/GradingQueue')            
      @gq.add_method('add_grader', 'grader_address', 'grader_port')
      @gq.add_method('test', 'grader_id', 'problem_id', 'submit_id', 'test_id', 'checker_id', 'module_id')      
      id = @gq.add_grader(params[:grader][:address],params[:grader][:port])
      flash[:notice] = "Grader was successfully added. with id #{id}"
      redirect_to :action => 'index'
    else
      flash[:notice]='Error'
      redirect_to :action => 'add_grader'
    end
  end
  
  def test
  end
  
  def create_test
    if 1
      @gq = SOAP::RPC::Driver.new('http://judge.openfmi.net:5004', 'urn:PCS/GradingQueue')            
      @gq.add_method('add_grader', 'grader_address', 'grader_port')
      @gq.add_method('test', 'grader_id', 'problem_id', 'submit_id', 'test_id', 'checker_id', 'module_id')
      id = @gq.test(
                      params[:test][:grader_id].to_i, 
                      params[:test][:problem_id].to_i, 
                      params[:test][:submit_id].to_i, 
                      params[:test][:test_id].split(',').each {|x| x.to_i} , 
                      params[:test][:checker_id].to_i, 
                      params[:test][:module_id].to_i
                   )
      flash[:notice] = "Testing with id #{id}"
      redirect_to :action => 'index'
    else
      flash[:notice]='Error'
      redirect_to :action => 'test'
    end
  end
  
  def delete_grader
  end
  
  def remove_grader
    @gq = SOAP::RPC::Driver.new('http://judge.openfmi.net:5004', 'urn:PCS/GradingQueue')
    @gq.add_method('delete_grader', 'grader_id')
    result = @gq.delete_grader(params[:grader][:id].to_i)
    flash[:notice] = "Grader with id #{id} removed"
    redirect_to :action => 'index'
  end
  
  def get_graders
    @gq = SOAP::RPC::Driver.new('http://judge.openfmi.net:5004', 'urn:PCS/GradingQueue')
    @gq.add_method('get_graders')
    @grader_ids = @gq.get_graders
  end
  
  def view_responce
    @grader_responses_list = PCS::Model::GraderResponse.find(:all)
  end
end
