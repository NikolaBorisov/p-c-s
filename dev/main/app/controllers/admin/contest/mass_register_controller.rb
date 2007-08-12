require 'faster_csv'

# Specifications:
# 
# 1) The tables columns must have these names: "Username", "Password", "First Name",
# "Last Name", "EMail", "Country", "City", "School", "Address", "Telephone", IN ANY ORDER !
#                         
# 2) When exporting to CSV format, the user must not leave empty rows and columns. So                          
# just remember to create your table starting from the first row/column of the spreadsheet !
# 
# 3) The newly generated usernames must not exist


  class MassRegister     
            
            def initialize( contest_id, username_prefix )
                                     
            
              @default_country = PCS::Model::Country.find_by_name("Bulgaria")         
              
              @contest = PCS::Model::Contest.find( contest_id )
              #TODO: Check for invalid contest_id
                            
              @username_prefix = username_prefix
                            
              #TODO: Think of different way of setting the password_len
              @password_len = 7
            end
            
            def register_from_csv_file(csv_input_file_name)
            
              csv_string = String.new
                            
              csv_string << ["Username", "Password", "First Name", "Last Name", "EMail", \
                         "Country", "City", "School", "Address", "Telephone"].to_csv
                                                  
                    
              FasterCSV.foreach(csv_input_file_name, { :headers => true, :header_converters => :symbol, :skip_blanks => true}){ |user_csv_info|
                 next unless( user_csv_info[:username] )
                                                  
                 user, text_password = get_user_object( user_csv_info )
                 

                 contest_privilege = PCS::Model::ContestPrivilege.new(\
                 :can_register => true, :register => true, :compete => false, :judge => false)
                 contest_privilege.user = user
                 contest_privilege.contest = @contest
                 contest_privilege.save
                                 
                                  
                 csv_string << [user.username, text_password, user.first_name, user.last_name, user.email, \
                 user.country.name, user.city, user.school, user.address, user.telephone].to_csv
              }
                        
               
              @contest.save(true)     
              
              return csv_string        
            end
            
            
            #Private methods            
            private
            
            def get_user_object( user_csv_info )
              user = PCS::Model::User.find_by_username( user_csv_info[:username] )
              
              return nil, nil if( user ) #The user should not exist
              
              user = PCS::Model::User.new();
              user.username = @username_prefix + user_csv_info[:username]
              
            
              text_password = generate_password( @password_len )   
              user.text_password = user.text_password_confirmation = text_password
              
              user.first_name = user_csv_info[:first_name]                
              user.last_name  = user_csv_info[:last_name]
              user.email      = user_csv_info[:email]
              given_country  =  PCS::Model::Country.find_by_name(user_csv_info[:country])
              given_country   =  @default_country unless( given_country )                               
              
              user.country   = given_country
              user.city      = user_csv_info[:city]

              #This information can be missed                
              user.address   = user_csv_info[:address]
              user.telephone = user_csv_info[:telephone]
              user.school    = user_csv_info[:school]
                                            
               puts "", "", user.username, user.email,\
               user.country, user.address, user.first_name, user.last_name,
               user.text_password, user.text_password_confirmation
               
              printf("Error in %s\n", user.username) if( !user.save )            
              
              return user, text_password              
            end
            
            def generate_password( pass_len )
              available_chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
              new_pass = ""
              pass_len.times{ new_pass << available_chars[ rand(available_chars.size - 1) ] }
              return new_pass
            end
  end
        
class Admin::Contest::MassRegisterController < ApplicationController

  def create
    if (request.get?)
      @csv_output = nil
    else
      csv_input_file_name = params[ :csv_input_file_name ]
      if( csv_input_file_name.instance_of?(StringIO))
        File.open( csv_input_file_name.original_filename, "w") { |f|
          f.write( csv_input_file_name.read )
        }
      end
      
     
      #TODO: Handel invalid params[:id]
      @contest = PCS::Model::Contest.find(params[:id])
      
      mass_register = MassRegister.new( @contest.id, (params[:username_prefix] or "") )
      @csv_output   = mass_register.register_from_csv_file( csv_input_file_name.original_filename )

    end
    
  end
  
end
