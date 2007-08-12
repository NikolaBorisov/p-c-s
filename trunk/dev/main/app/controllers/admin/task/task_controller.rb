include PCS::WEB::TASK_CONTROLLER_SUPPORT

class Admin::Task::TaskController < ApplicationController
   before_filter :authorize_admin
   
 def index()
  redirect_to(:action => :list)
 end
 
 def list()
    puts( session[:user_id] )
    user = PCS::Model::User.find( session[:user_id] )    
    @tasks = user.tasks()    
 end
       
 def edit()    
    #if params[:id] == nil, we create new task, otherwise edit the old one
    @task = valid_task( params[ :id ] )
    @task = PCS::Model::Task.new() unless( @task )    
    
    @view_component = nil
    
    case( params[ :view ].to_i )
      when 1 #Show Task Tests
    
      #We easy the author to add the first free test number
       @next_test = 1   
       @task.tests.each { |curr|    
          @next_test += 1 if( @next_test==curr.number)
       }
       @view_component = 'admin/task/test/list'
       
      when 2 #Show Task Modules       
       @view_component = 'admin/task/module/list'
      when 3 #Show Task Checkers    
       @view_component = 'admin/task/checker/list'
      when 4 #Show Task Contents
       @view_component = 'admin/task/content/list'
      when 5 #Show Task Restrictions
       @view_component = 'admin/task/restriction/list'
       
      when 6 #Show Task Privileges
        @view_component = 'admin/task/privileges/list'
        curr_user = PCS::Model::User.find( session[:user_id] )  
        @is_owner = ( curr_user == @task.owner ) ? true : false  
            
        @users_for_options = [ ["Select user"] ]
            
        PCS::Model::User.find(:all).each { |user|          
          unless( user.tasks.find(:first, :conditions=>["name=?", @task.name]) )
            @users_for_options << [ user.username, user.id ]
          end
        }         
                
      end
    
 end
    
 def save()  
      update = false
            
      @task = valid_task( params[:task][:id] )
      
      update = true if( @task )
      
      
      @task=PCS::Model::Task.new() if( !update )
      
      @task.title = params[ :task ][ :title ]
      @task.name = params[ :task ][ :name ]
      @task.task_type = params[ :task ][ :task_type ]
      @task.difficulty = params[ :task ][ :difficulty ]      
      
      owner = PCS::Model::User.find( session[:user_id] )
      
      @task.owner = owner
            
      @task.privileged_users << owner if( !update )
    
      if( @task.save!() )
        redirect_to_task("Task #{@task.name} succesfully saved with id #{@task.id}", @task.id, nil)
      else
        render( :action => :edit )
      end          
    
 end

def delete()
  task = valid_task( params[ :id ]  )
  redirect_to_index("Select Task First") and return unless( task )
     
  task.destroy()
  
  redirect_to_index("Task Deleted")
end




end
