# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  RAND_MAX = 1000000000
  
  attr_accessor(:message)  
  attr_accessor(:window_id)
  
  
  def authorize 
    unless session[:user_id]
      info("Please log in")
      redirect_message( :controller => "/login" , :action => "login" )
    end
  end
  
  
  def authorize_admin
    puts session[:admin], session[:admin].class
    unless session[:admin]
      info("You have no permission to access this resource")
      redirect_message(:controller => "/login" , :action => "login" )
    end
  end
  
  
  def info(message, type = "error") 
    @message = {:msg_text => message, :msg_type => type}
  end
  
  
  def redirect_message(destination_hash, params_hash = Hash.new)
    params_hash[:message] = @message
    redirect(destination_hash, params_hash)
  end
  
  
  def redirect(destination_hash, params_hash)
    rnd = rand(RAND_MAX).to_s
    
    session[rnd] = params_hash
    destination_hash[:window_id] = rnd
    
    redirect_to(destination_hash)
  end
  
  # Functions to use to send jobs to GQ Module
  # TODO: OPTIMIZE THE CODE, IT IS NOW UGLY
  def send_submit(contest_id, task_id, submit_id)
    contest_type_name = get_contest_type_name(contest_id)
    checker_id = get_checker_id(contest_id, task_id, PCS::Model::ContestChecker::SUBMIT_ACTION)
    module_id = get_module_id(contest_id, task_id, PCS::Model::ContestChecker::SUBMIT_ACTION)
    test_ids = get_test_ids_for_submit(task_id, contest_type_name)
    
    grading_id = test_request(-1, task_id, submit_id, test_ids, checker_id, module_id )
    return grading_id
  end  
  
  def send_grade(contest_id, task_id, submit_id)
    contest_type_name = get_contest_type_name(contest_id)
    checker_id = get_checker_id(contest_id, task_id, PCS::Model::ContestChecker::GRADE_ACTION)
    module_id = get_module_id(contest_id, task_id, PCS::Model::ContestChecker::GRADE_ACTION)
    test_ids = get_test_ids_for_submit(task_id, contest_type_name)
    
    grading_id = test_request(-1, task_id, submit_id, test_ids, checker_id, module_id )
    return grading_id
  end
  
  # Returns the name of the type of the contest by given contest_id
  def get_contest_type_name(contest_id)
    PCS::Model::Contest.find(contest_id).contest_type.name
  end
  
  def get_checker_id(contest_id, task_id, action)
    contest_checker_for_submit = PCS::Model::ContestChecker.find(:first, 
                                                                 :conditions => ["contest_id = ? AND task_id = ? AND action = ?", 
    contest_id, task_id, action])    
    
    return contest_checker_for_submit.checker_id
  end
  
  def get_module_id(contest_id, task_id, action)
    contest_module_for_submit = PCS::Model::ContestModule.find(:first, 
                                                               :conditions => ["contest_id = ? AND task_id = ? AND action = ?", 
    contest_id, task_id, action])
    
    if ( contest_module_for_submit )
      return contest_module_for_submit.module_id
    else
      return nil
    end
  end
  
  def get_test_ids_for_submit(task_id, contest_type)
    case contest_type
    when "IOI"
      test = PCS::Model::Test.find(:first, :conditions => ["task_id = ? AND number = 0", task_id])
      if test
        return [test.test_id]      
      else
        return nil
      end
    when "ACM"
    end
  end
  
  def get_test_ids_for_grade(task_id, contest_type)
    case contest_type
    when "IOI"
      tests = PCS::Model::Test.find(:all, :conditions => ["task_id = ?", task_id])
      tests_ids = []
      
      if tests
        tests.each { |test| tests_ids << test.id }
        return tests_ids      
      else
        return nil
      end
    when "ACM"
    end
  end
  
  def test_request(grader_id, task_id, submit_id, tests_ids, checker_id, module_id)
    @gq = SOAP::RPC::Driver.new("#{$my_config[:grading_queue][:address]}:#{$my_config[:grading_queue][:port]}", $my_config[:grading_queue][:namespace])
    @gq.add_method('test', 'grader_id', 'problem_id', 'submit_id', 'test_id', 'checker_id', 'module_id')    
    grading_id = @gq.test(grader_id, task_id, submit_id, tests_ids, checker_id, module_id)
    return grading_id
  end
  
end