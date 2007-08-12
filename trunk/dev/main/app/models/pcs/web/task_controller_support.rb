
module PCS
	module WEB
		module TASK_CONTROLLER_SUPPORT
  
		  def is_number( x )
		    return x unless( x )
		    return x.to_s() =~ /^[0-9]+$/ 
		  end
  
		  def valid_task( task_id )  
		    return task = PCS::Model::Task.find( :first, :conditions => ["task_id = ?", task_id ] ) if( is_number( task_id ) )
		  end
  
		  def valid_test( test_id )
		    return PCS::Model::Test.find( :first, :conditions => ["test_id = ?", test_id ] ) if( is_number( test_id ) )
		  end
  
		  def valid_module( module_id )
		    return PCS::Model::Module.find( :first, :conditions => ["module_id = ?", module_id ] ) if( is_number( module_id ) )
		  end
  
		  def valid_checker( checker_id )
		    return PCS::Model::Checker.find( :first, :conditions => ["checker_id = ?", checker_id ] ) if( is_number( checker_id ) )
		  end
  
		  def valid_content( task_content_id )
		    return PCS::Model::TaskContent.find( :first, :conditions => ["task_content_id = ?", task_content_id ] ) if( is_number( task_content_id ) )
		  end
  
		  def valid_user( user_id )
		    return PCS::Model::User.find( :first, :conditions => ["user_id = ?", user_id ] ) if( is_number( user_id ) )
		  end
  
		  def valid_restriction( restriction_id )
		      return PCS::Model::Restriction.find( :first, :conditions => ["restriction_id = ?", restriction_id ] ) if( is_number( restriction_id ) )
		  end

  
		  def redirect_to_index( msg )
		    info(msg) if( msg )
		    redirect_message( :controller => 'task', :action => :list )
		  end
  
		  def redirect_to_task( msg, id, view )
		      info(msg) if( msg )
		      redirect_message( :controller => 'task', :action => :edit, :id => id, :view => view )
		  end  
  
		end
	end
end