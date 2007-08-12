include PCS::WEB::TASK_CONTROLLER_SUPPORT

class Admin::Task::ContentController < ApplicationController

 def edit()
  task = valid_task( params[:id] )
  redirect_to_index("Invalid task") and return unless ( task )
  
  @task_content = valid_content( params[:task_content_id])  
  @task_content = PCS::Model::TaskContent.new() unless( @task_content )
   
  if( request.get? )
      @languages = PCS::Model::Language.find(:all, :order => "name").map{ |lang| [lang.name, lang.id] } 
  else    
    @task_content.language = PCS::Model::Language.find( params[:task_content][:language_id])
    @task_content.content = params[:task_content][:content]
    @task_content.task = task
    @task_content.save()
       
    redirect_to_task("Content saved", task.id, 4)             
  end
  
 end

 def view()
  @task_content = valid_content( params[:task_content_id] )
  redirect_to_index("Invalid task") and return unless( @task_content )  
 end

 def delete()
  task_content = valid_content( params[:id] )
  redirect_to_index("Invalid task") and return unless( task_content )  
  task_id = task_content.task.id  
  
  task_content.destroy()
  
  redirect_to_task("Contest deleted", task_id, 4)
 end
 
end
