class TaskController < ApplicationController
  before_filter :set_login_user
 
 def list_tasks()
    puts( session[:user_id] )
    user = PCS::Model::User.find( session[:user_id] )
    #get all the tasks on wich the user has some privileges
    @tasks = user.tasks()    
 end
       
 def edit_task()    
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
       @view_component = 'view_task_tests'
       
      when 2 #Show Task Modules
       
       @view_component = 'view_task_modules'
       
       
      when 3 #Show Task Checkers
    
       @view_component = 'view_task_checkers'
       
      when 4 #Show Task Contents

       @view_component = 'view_task_contents' 
    end
    
 end
    
 def save_task()  
      update = false
            
      @task = valid_task( params[:task][:id] )
      
      update = true if( @task )
      
      @task=PCS::Model::Task.new() if( !update )
      
      @task.title = params[ :task ][ :title ]
      @task.name = params[ :task ][ :name ]
      @task.task_type = params[ :task ][ :task_type ]
      @task.difficulty = params[ :task ][ :difficulty ]      
      
      owner = PCS::Model::User.find( session[:user_id] )
      @task.owner  = owner
      
      @task.privileged_users << owner if( !update )
    
      if( @task.save() )
        redirect_to_task("Task #{@task.name} succesfully saved with id #{@task.id}", @task.id, nil)
      else
        render( :action => :edit_task )
      end          
    
 end


 def add_test()  
   @task = valid_task( params[ :id ] )
   number = params[:number]

   #Handel invalid params
   redirect_to_task("Invalid Task", params[:id], 1) and return unless( @task )    
   redirect_to_task("Invalid Number", params[:id], 1) and return unless( is_number(number) )
   
   test = @task.tests.find(:first, :conditions => ["number = ?", number ] )
   redirect_to_task("Test #{test.number} Exist", params[:id], 1) and return if( test )  
   
   test = PCS::Model::Test.new()
   test.number = number
   @task.tests << test  
   test.save()  
   
#   redirect_to_task( nil, params[:id], 1)   
    redirect_to(:action => :edit_test, :id => test.id)
 end

 def edit_test()
  
  test = valid_test( params[ :id ] )  
  redirect_to_index("Select test first") and return unless( test )    
  
  if ( request.get? )       
    @test_number = test.number   
  else   
      file_inp = PCS::Model::File.save_file( params[ :file_inp ] )
      file_out = PCS::Model::File.save_file( params[ :file_out ] )
        
           
      if(file_inp)
        del_test_file( test, PCS::FileDescription::INPUT)
        @test_file  = PCS::Model::TestFile.new()
        @test_file.test_type = PCS::FileDescription::INPUT
        @test_file.file = file_inp
        @test_file.test = test
        @test_file.save()
        
      else   
        #TODO: Handle the error       
      end 
      
      if(file_out)  
        del_test_file( test, PCS::FileDescription::OUTPUT)
        @test_file  = PCS::Model::TestFile.new()
        @test_file.test_type = PCS::FileDescription::OUTPUT
        @test_file.file = file_out
        @test_file.test = test
        @test_file.save()      
      else          
        #TODO: Handle the error
      end
      
      redirect_to( :action => :edit_task, :id => test.task.id, :view => 1 )
  end
  
 end

 def del_test()
  test_id = params[ :id ].to_i()
  #TODO: Handel invalid test_id
  
  test = PCS::Model::Test.find( test_id )
  task_id = test.task_id
  
  #files_to_delete = []
  #test.files.each { |f| files_to_delete << f }
  #test.destroy()
  #files_to_delete.each { |f| f.destroy() }
    
  del_test_file( test, PCS::FileDescription::INPUT)
  del_test_file( test, PCS::FileDescription::OUTPUT)
  test.destroy()
  
  redirect_to_task("Deleted!!!", task_id, 1)
 end



def edit_module()
  task = valid_task( params[:id] )
  @mod = valid_module( params[:module_id] )

  if( request.get? )  
   
  else        
       
    @mod = PCS::Model::Module.new() unless( @mod )          
     
    @mod.name = params[:mod][:name]  
    @mod.task = task
    @mod.save()
    
    
    file_module = ( params[:file_module] ) ? PCS::Model::File.save_file( params[:file_module] )  : nil
    file_header = ( params[:file_header] ) ? PCS::Model::File.save_file( params[:file_header] )  : nil
        
    if( file_module )
      module_file = PCS::Model::ModuleFile.new()
      module_file.file = file_module
      module_file.module_type = PCS::FileDescription::MODULE
      module_file.modul = @mod
      module_file.save()
    end        
    
    if( file_header )
      module_file = PCS::Model::ModuleFile.new()
      module_file.file = file_header
      module_file.module_type = PCS::FileDescription::HEADER
      module_file.modul = @mod
      module_file.save()
    end        
    
    
    redirect_to_task( "Module saved", task.id, 2 )
  end
    
end

def del_module()
  #:id => which module to delete
  #:module_file_id => which module_file(if nil, all modules_files) of the module to delete
  mod = valid_module( params[:id] )
  #TODO: Handel invalid module
    
  module_file_id = params[:module_file_id]
  module_file_id = module_file_id.to_i() if( module_file_id )
  
  files_to_delete = []
  mod.modules_files.each { |module_file|
    files_to_delete << module_file.file if( module_file_id==module_file.id || module_file_id==nil)
  }
  
  files_to_delete.each { |f|
    #first destroy the relation in modules_files table
    f.modules_files.each { |mf| mf.destroy() }
    
    #than destroy the file in files table
    f.destroy()
  }  
  
  task_id = mod.task.id
  mod.destroy() unless( module_file_id )
  redirect_to_task("Module file(s) deleted", task_id, 2)
end


def edit_checker()
    task = valid_task( params[:id] )
    redirect_to_index("Invalid task") and return unless( task )
    
    @checker = valid_checker( params[:checker_id] )
    @checker = PCS::Model::Checker.new() unless( @checker )
    
    if( request.get? )
        @program_languages = PCS::Model::ProgramLanguage.find(:all, :order => "name").map{ |plang| [plang.name, plang.id] }            
    else
      @checker.name = params[:checker][:name]
      @checker.program_language = PCS::Model::ProgramLanguage.find( params[:checker][:program_language_id] )
      @checker.task = task
      
      file = PCS::Model::File.save_file( params[:file] )
      
      if( file )
        @checker.file.destroy() if( @checker.file )
        @checker.file = file
      end
       
      @checker.save()       
      redirect_to_task("Checker successfully added", task.id, 3)     
    end  
end

def del_checker()
  checker = valid_checker( params[:id] )  
  redirect_to_index("Invalid checker") and return unless( checker )  
  task_id = checker.task.id
  file = checker.file
  checker.destroy()
  file.destroy()
  redirect_to_task("Checker deleted", task_id, 3)
end

def edit_task_content()
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
    
    if( @task_content.save() )
      redirect_to_task("Content successfully saved", task.id, 4)     
    else
      redirect_to_task("Error sving", task.id, 4)     
    end
    
  end
  
end

def view_task_content()
  @task_content = valid_content( params[:task_content_id] )
  redirect_to_index("Invalid task") and return unless( @task_content )  
end

def del_task_content()
  task_content = valid_content( params[:id] )
  redirect_to_index("Invalid task") and return unless( task_content )  
  task_id = task_content.task.id  
  task_content.destroy();
  redirect_to_task("Contest deleted", task_id, 4)
end


#Private methods
private  
  
  def del_test_file( test, type )
    test.tests_files.each { |test_file|
      if( test_file.test_type==type )
         file = test_file.file
         
         
         #first delete the relation in tests_files table
         file.tests_files.each{ |f| f.destroy() } #or test_file.destroy()
         
         #than destroy the file
         file.destroy()
      end
    }
  end
    
  
  def set_login_user()
    #simulate that there is login user with author role
    unless( session[ :user_id ] )
      session[ :user_id ] = PCS::Model::User.find_by_username('author1').id
    end
  end

  def is_number( x )
    return x.to_s() =~ /^[0-9]+$/
  end
  
  def valid_task( task_id )  
    task = PCS::Model::Task.find( :first, :conditions => "task_id = #{task_id}" ) if( task_id && is_number( task_id ) )  
    return task
  end
  
  def valid_test( test_id )
    return PCS::Model::Test.find( :first, :conditions => ["test_id = ?", test_id ] ) if( test_id && is_number( test_id ) )
  end
  
  def valid_module( module_id )
    return PCS::Model::Module.find( :first, :conditions => ["module_id = ?", module_id ] ) if( module_id && is_number( module_id ) )
  end
  
  def valid_checker( checker_id )
    return PCS::Model::Checker.find( :first, :conditions => ["checker_id = ?", checker_id ] ) if( checker_id && is_number( checker_id ) )
  end
  
  def valid_content( task_content_id )
    return PCS::Model::TaskContent.find( :first, :conditions => ["task_content_id = ?", task_content_id ] ) if( task_content_id && is_number( task_content_id ) )
  end
  
  def redirect_to_index( msg )
    flash[:notice] = msg if( msg )
    redirect_to(:action => :list_tasks)
  end
  
  def redirect_to_task( msg, id, view )
      flash[ :notice ] = msg
      redirect_to( :action => :edit_task, :id => id, :view => view )      
  end


end
