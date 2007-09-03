include PCS::WEB::TASK_CONTROLLER_SUPPORT

class Admin::Task::TestController < ApplicationController
#  before_filter :authorize_admin
  before_filter :authorize

  def add()
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

    redirect_to(:action => :edit, :id => test.id)
  end

  def edit()

    test = valid_test( params[ :id ] )
    redirect_to_index("Invali test") and return unless( test )

    if ( request.get? )
      @test_number = test.number
    else
      file_inp = PCS::Model::File.save_file( params[ :file_inp ] )
      file_out = PCS::Model::File.save_file( params[ :file_out ] )


      if(file_inp)
        del_test_file( test, PCS::FileDescription::INPUT)
        test_file  = PCS::Model::TestFile.new()
        test_file.test_type = PCS::FileDescription::INPUT
        test_file.file = file_inp
        test_file.test = test
        test_file.save()

      else
        #TODO: Handle the error
      end

      if(file_out)
        del_test_file( test, PCS::FileDescription::SOLUTION)
        test_file  = PCS::Model::TestFile.new()
        test_file.test_type = PCS::FileDescription::SOLUTION
        test_file.file = file_out
        test_file.test = test
        test_file.save()
      else
        #TODO: Handle the error
      end

      redirect_to( :controller => 'task', :action => :edit, :id => test.task.id, :view => 1 )
    end

  end

  def delete()
    test = valid_test( params[ :id ] )
    redirect_to_index("Invalid Test") and return unless( test )

    task_id = test.task_id

    test.destroy()

    redirect_to_task("Test Deleted!!!", task_id, 1)
  end

  #Private methods
  private

  def del_test_file( test, type )
    test.tests_files.each { |test_file|
      test_file.destroy() if( test_file.test_type==type )
    }
  end

end
