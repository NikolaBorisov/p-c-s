# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 1) do

  create_table "article_contents", :id => false, :force => true do |t|
    t.column "article_content_id", :integer,                 :null => false
    t.column "article_id",         :integer, :default => 0,  :null => false
    t.column "language_id",        :integer, :default => 0,  :null => false
    t.column "content",            :text,    :default => "", :null => false
  end

  add_index "article_contents", ["article_id"], :name => "FK_article_contents_articles"
  add_index "article_contents", ["language_id"], :name => "FK_article_contents_languages"

  create_table "articles", :id => false, :force => true do |t|
    t.column "article_id",   :integer,                                :null => false
    t.column "name",         :string,  :limit => 32,  :default => "", :null => false
    t.column "title",        :string,  :limit => 256, :default => "", :null => false
    t.column "owner_id",     :integer,                                :null => false
    t.column "article_type", :integer,                                :null => false
  end

  add_index "articles", ["owner_id"], :name => "FK_articles_owners"

  create_table "articles_classes", :id => false, :force => true do |t|
    t.column "article_id", :integer, :null => false
    t.column "class_id",   :integer, :null => false
  end

  add_index "articles_classes", ["article_id"], :name => "FK_articles_classes_articles"
  add_index "articles_classes", ["class_id"], :name => "FK_articles_classes_classes"

  create_table "articles_files", :id => false, :force => true do |t|
    t.column "article_id", :integer, :null => false
    t.column "file_id",    :integer, :null => false
  end

  add_index "articles_files", ["article_id"], :name => "FK_articles_files_articles"
  add_index "articles_files", ["file_id"], :name => "FK_articles_files_files"

  create_table "articles_privileges", :id => false, :force => true do |t|
    t.column "article_id", :integer, :null => false
    t.column "user_id",    :integer, :null => false
  end

  add_index "articles_privileges", ["article_id"], :name => "FK_articles_privileges_articles"
  add_index "articles_privileges", ["user_id"], :name => "FK_articles_privileges_users"

  create_table "board_types", :id => false, :force => true do |t|
    t.column "board_type_id", :integer,                                :null => false
    t.column "name",          :string,  :limit => 256, :default => "", :null => false
  end

  create_table "checker_responses", :id => false, :force => true do |t|
    t.column "checker_response_id", :integer,                                 :null => false
    t.column "status",              :integer,                                 :null => false
    t.column "message",             :string,  :limit => 2048, :default => "", :null => false
    t.column "correctness",         :float,                                   :null => false
    t.column "user_time",           :integer,                                 :null => false
    t.column "system_time",         :integer,                                 :null => false
    t.column "exit_status",         :integer,                                 :null => false
    t.column "term_sig",            :integer
  end

  create_table "checkers", :id => false, :force => true do |t|
    t.column "checker_id",          :integer,                                :null => false
    t.column "name",                :string,  :limit => 256, :default => "", :null => false
    t.column "file_id",             :integer,                                :null => false
    t.column "task_id",             :integer,                                :null => false
    t.column "program_language_id", :integer,                                :null => false
  end

  add_index "checkers", ["file_id"], :name => "FK_checkers_files"
  add_index "checkers", ["task_id"], :name => "FK_checkers_tasks"
  add_index "checkers", ["program_language_id"], :name => "FK_checkers_program_languages"

  create_table "classes", :id => false, :force => true do |t|
    t.column "class_id", :integer,                                :null => false
    t.column "name",     :string,  :limit => 256, :default => "", :null => false
  end

  create_table "compiler_options", :id => false, :force => true do |t|
    t.column "compiler_option_id",  :integer,                                 :null => false
    t.column "command_line",        :string,  :limit => 2048, :default => "", :null => false
    t.column "time_limit",          :integer,                                 :null => false
    t.column "program_language_id", :integer,                                 :null => false
  end

  add_index "compiler_options", ["program_language_id"], :name => "FK_compiler_options_program_languages"

  create_table "compiler_responses", :id => false, :force => true do |t|
    t.column "compiler_response_id", :integer,                                 :null => false
    t.column "status",               :integer,                                 :null => false
    t.column "message",              :string,  :limit => 256,  :default => "", :null => false
    t.column "compiler_output",      :string,  :limit => 2048, :default => "", :null => false
    t.column "user_time",            :integer,                                 :null => false
    t.column "system_time",          :integer,                                 :null => false
    t.column "exit_status",          :integer,                                 :null => false
    t.column "term_sig",             :integer
  end

  create_table "contest_privileges", :id => false, :force => true do |t|
    t.column "contest_id",   :integer,                   :null => false
    t.column "user_id",      :integer,                   :null => false
    t.column "judge",        :boolean,                   :null => false
    t.column "register",     :boolean,                   :null => false
    t.column "compete",      :boolean,                   :null => false
    t.column "can_register", :boolean, :default => true
  end

  add_index "contest_privileges", ["contest_id"], :name => "FK_contest_privileges_contests"
  add_index "contest_privileges", ["user_id"], :name => "FK_contest_privileges_users"

  create_table "contest_types", :id => false, :force => true do |t|
    t.column "contest_type_id", :integer,                                :null => false
    t.column "name",            :string,  :limit => 256, :default => "", :null => false
  end

  create_table "contests", :id => false, :force => true do |t|
    t.column "contest_id",      :integer,                                  :null => false
    t.column "name",            :string,   :limit => 256,  :default => "", :null => false
    t.column "title",           :string,   :limit => 1024, :default => "", :null => false
    t.column "start_time",      :datetime
    t.column "end_time",        :datetime
    t.column "duration",        :time
    t.column "board_type_id",   :integer,                                  :null => false
    t.column "contest_type_id", :integer,                                  :null => false
    t.column "is_private",      :boolean,                                  :null => false
    t.column "owner_id",        :integer,                                  :null => false
  end

  add_index "contests", ["board_type_id"], :name => "FK_contests_board_types"
  add_index "contests", ["contest_type_id"], :name => "FK_contests_contest_types"
  add_index "contests", ["owner_id"], :name => "FK_contests_owners"

  create_table "contests_checkers", :id => false, :force => true do |t|
    t.column "contest_checker_id", :integer, :null => false
    t.column "contest_id",         :integer, :null => false
    t.column "checker_id",         :integer, :null => false
    t.column "task_id",            :integer, :null => false
    t.column "action",             :integer, :null => false
  end

  add_index "contests_checkers", ["contest_id"], :name => "FK_contests_checkers_contests"
  add_index "contests_checkers", ["checker_id"], :name => "FK_contests_checkers_checkers"
  add_index "contests_checkers", ["task_id"], :name => "FK_contests_checkers_tasks"

  create_table "contests_modules", :id => false, :force => true do |t|
    t.column "contest_module_id",   :integer, :null => false
    t.column "contest_id",          :integer, :null => false
    t.column "module_id",           :integer, :null => false
    t.column "task_id",             :integer, :null => false
    t.column "action",              :integer, :null => false
    t.column "program_language_id", :integer, :null => false
  end

  add_index "contests_modules", ["contest_id"], :name => "FK_contests_modules_contests"
  add_index "contests_modules", ["module_id"], :name => "FK_contests_modules_modules"
  add_index "contests_modules", ["task_id"], :name => "FK_contests_modules_tasks"
  add_index "contests_modules", ["program_language_id"], :name => "FK_contests_modules_program_languages"

  create_table "contests_tasks", :id => false, :force => true do |t|
    t.column "contest_id",     :integer,                :null => false
    t.column "task_id",        :integer,                :null => false
    t.column "number",         :integer,                :null => false
    t.column "restriction_id", :integer, :default => 0, :null => false
  end

  add_index "contests_tasks", ["contest_id"], :name => "FK_contests_tasks_contests"
  add_index "contests_tasks", ["task_id"], :name => "FK_contests_tasks_tasks"

  create_table "countries", :id => false, :force => true do |t|
    t.column "country_id", :integer,                                :null => false
    t.column "name",       :string,  :limit => 256, :default => "", :null => false
    t.column "code",       :string,  :limit => 2,   :default => "", :null => false
  end

  create_table "files", :id => false, :force => true do |t|
    t.column "file_id", :integer,                                :null => false
    t.column "name",    :string,  :limit => 256, :default => "", :null => false
  end

  create_table "grader_responses", :id => false, :force => true do |t|
    t.column "grader_response_id",            :integer,                 :null => false
    t.column "submit_id",                     :integer,                 :null => false
    t.column "module_id",                     :integer,                 :null => false
    t.column "checker_id",                    :integer,                 :null => false
    t.column "solution_compiler_response_id", :integer,                 :null => false
    t.column "checker_compiler_response_id",  :integer,                 :null => false
    t.column "message",                       :text,    :default => "", :null => false
    t.column "status",                        :integer,                 :null => false
  end

  add_index "grader_responses", ["submit_id"], :name => "FK_grader_responses_submits"
  add_index "grader_responses", ["module_id"], :name => "FK_grader_responses_modules"
  add_index "grader_responses", ["checker_id"], :name => "FK_grader_responses_checkers"
  add_index "grader_responses", ["solution_compiler_response_id"], :name => "FK_grader_responses_compiler_responses1"
  add_index "grader_responses", ["checker_compiler_response_id"], :name => "FK_grader_responses_compiler_responses2"

  create_table "languages", :id => false, :force => true do |t|
    t.column "language_id", :integer,                               :null => false
    t.column "name",        :string,  :limit => 64, :default => "", :null => false
    t.column "code",        :string,  :limit => 2,  :default => "", :null => false
  end

  create_table "modules", :id => false, :force => true do |t|
    t.column "module_id", :integer,                                :null => false
    t.column "name",      :string,  :limit => 256, :default => "", :null => false
    t.column "task_id",   :integer,                                :null => false
  end

  add_index "modules", ["task_id"], :name => "FK_modules_tasks"

  create_table "modules_files", :id => false, :force => true do |t|
    t.column "module_file_id", :integer, :null => false
    t.column "module_id",      :integer, :null => false
    t.column "file_id",        :integer, :null => false
    t.column "module_type",    :integer, :null => false
  end

  add_index "modules_files", ["file_id"], :name => "FK_modules_files_files"
  add_index "modules_files", ["module_id"], :name => "FK_modules_files_modules"

  create_table "program_languages", :id => false, :force => true do |t|
    t.column "program_language_id", :integer,                                :null => false
    t.column "name",                :string,  :limit => 256, :default => "", :null => false
  end

  create_table "restrictions", :id => false, :force => true do |t|
    t.column "restriction_id",   :integer, :null => false
    t.column "task_id",          :integer, :null => false
    t.column "runtime",          :integer, :null => false
    t.column "memory",           :integer, :null => false
    t.column "stack_size",       :integer, :null => false
    t.column "source_code",      :integer, :null => false
    t.column "output_size",      :integer, :null => false
    t.column "compilation_time", :integer, :null => false
  end

  add_index "restrictions", ["task_id"], :name => "FK_restrictions_tasks"

  create_table "roles", :id => false, :force => true do |t|
    t.column "role_id",     :integer,                               :null => false
    t.column "name",        :string,  :limit => 32, :default => "", :null => false
    t.column "description", :text,                  :default => "", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.column "role_id", :integer, :null => false
    t.column "user_id", :integer, :null => false
  end

  add_index "roles_users", ["role_id"], :name => "FK_roles_users_roles"
  add_index "roles_users", ["user_id"], :name => "FK_roles_users_users"

  create_table "sample_solutions", :id => false, :force => true do |t|
    t.column "sample_solution_id", :integer,                                :null => false
    t.column "name",               :string,  :limit => 256, :default => "", :null => false
    t.column "file_id",            :integer,                                :null => false
    t.column "task_id",            :integer,                                :null => false
  end

  add_index "sample_solutions", ["file_id"], :name => "FK_sample_solutions_files"
  add_index "sample_solutions", ["task_id"], :name => "FK_sample_solutions_tasks"

  create_table "submits", :id => false, :force => true do |t|
    t.column "submit_id",                    :integer,                 :null => false
    t.column "user_id",                      :integer,                 :null => false
    t.column "file_id",                      :integer,                 :null => false
    t.column "task_id",                      :integer,                 :null => false
    t.column "program_language_id",          :integer,                 :null => false
    t.column "submit_at",                    :datetime
    t.column "contest_id",                   :integer,  :default => 0, :null => false
    t.column "last_full_grader_response_id", :integer
  end

  add_index "submits", ["user_id"], :name => "FK_submits_users"
  add_index "submits", ["file_id"], :name => "FK_submits_files"
  add_index "submits", ["task_id"], :name => "FK_submits_tasks"
  add_index "submits", ["program_language_id"], :name => "FK_submits_program_languages"

  create_table "task_contents", :id => false, :force => true do |t|
    t.column "task_contest_id", :integer,                 :null => false
    t.column "task_id",         :integer,                 :null => false
    t.column "language_id",     :integer,                 :null => false
    t.column "content",         :text,    :default => "", :null => false
  end

  add_index "task_contents", ["task_id"], :name => "FK_task_contents_tasks"
  add_index "task_contents", ["language_id"], :name => "FK_task_contents_languages"

  create_table "tasks", :id => false, :force => true do |t|
    t.column "task_id",    :integer,                                :null => false
    t.column "name",       :string,  :limit => 32,  :default => "", :null => false
    t.column "title",      :string,  :limit => 256, :default => "", :null => false
    t.column "owner_id",   :integer,                                :null => false
    t.column "task_type",  :integer,                                :null => false
    t.column "difficulty", :integer,                                :null => false
  end

  add_index "tasks", ["owner_id"], :name => "FK_tasks_owners"

  create_table "tasks_classes", :id => false, :force => true do |t|
    t.column "task_id",  :integer, :null => false
    t.column "class_id", :integer, :null => false
  end

  add_index "tasks_classes", ["task_id"], :name => "FK_tasks_classes_tasks"
  add_index "tasks_classes", ["class_id"], :name => "FK_tasks_classes_classes"

  create_table "tasks_privileges", :id => false, :force => true do |t|
    t.column "user_id", :integer, :null => false
    t.column "task_id", :integer, :null => false
  end

  add_index "tasks_privileges", ["user_id"], :name => "FK_tasks_privileges_users"
  add_index "tasks_privileges", ["task_id"], :name => "FK_tasks_privileges_tasks"

  create_table "test_responses", :id => false, :force => true do |t|
    t.column "test_response_id",    :integer,                                :null => false
    t.column "grader_response_id",  :integer,                                :null => false
    t.column "checker_response_id", :integer,                                :null => false
    t.column "test_id",             :integer,                                :null => false
    t.column "status",              :integer,                                :null => false
    t.column "message",             :string,  :limit => 256, :default => "", :null => false
    t.column "user_time",           :integer,                                :null => false
    t.column "system_time",         :integer,                                :null => false
    t.column "memory_usage",        :integer,                                :null => false
    t.column "exit_status",         :integer,                                :null => false
    t.column "term_sig",            :integer
  end

  add_index "test_responses", ["grader_response_id"], :name => "FK_test_responses_grader_responses"
  add_index "test_responses", ["checker_response_id"], :name => "FK_test_responses_checker_responses"
  add_index "test_responses", ["test_id"], :name => "FK_test_responses_tests"

  create_table "tests", :id => false, :force => true do |t|
    t.column "test_id", :integer, :null => false
    t.column "number",  :integer, :null => false
    t.column "task_id", :integer, :null => false
  end

  add_index "tests", ["task_id"], :name => "FK_tests_tasks"

  create_table "tests_files", :id => false, :force => true do |t|
    t.column "test_file_id", :integer, :null => false
    t.column "test_id",      :integer, :null => false
    t.column "file_id",      :integer, :null => false
    t.column "test_type",    :integer, :null => false
  end

  add_index "tests_files", ["file_id"], :name => "FK_tests_files_files"
  add_index "tests_files", ["test_id"], :name => "FK_tests_files_tests"

  create_table "users", :id => false, :force => true do |t|
    t.column "user_id",    :integer,                                :null => false
    t.column "username",   :string,  :limit => 32,  :default => "", :null => false
    t.column "password",   :string,  :limit => 40,  :default => "", :null => false
    t.column "first_name", :string,  :limit => 64,  :default => "", :null => false
    t.column "last_name",  :string,  :limit => 64,  :default => "", :null => false
    t.column "country_id", :integer,                                :null => false
    t.column "email",      :string,  :limit => 128, :default => "", :null => false
    t.column "city",       :string,  :limit => 64,  :default => "", :null => false
    t.column "address",    :text
    t.column "telephone",  :string,  :limit => 64,  :default => ""
    t.column "school",     :string,  :limit => 128, :default => ""
  end

  add_index "users", ["country_id"], :name => "FK_users_countries"

end
