DROP DATABASE IF EXISTS pcs;
CREATE DATABASE pcs;

USE pcs;

#####
# Languages table contains the full language names and their 2-letter codes (ISO)
#####

CREATE TABLE languages (
	language_id         INTEGER         NOT NULL AUTO_INCREMENT,
	name                VARCHAR(64)     NOT NULL,
	code                CHAR(2)         NOT NULL,
	  
	PRIMARY KEY (language_id)
);

#####
# contries table contains the full countires names and their 2-letter codes (ISO)
#####

CREATE TABLE countries (
    country_id          INTEGER         NOT NULL AUTO_INCREMENT,
    name                VARCHAR(256)    NOT NULL,
    code                CHAR(2)         NOT NULL,

    PRIMARY KEY (country_id)
);

#####
# Files table contains the names of files and is used by the File Server to store the files
#####

CREATE TABLE files (
    file_id             INTEGER         NOT NULL AUTO_INCREMENT,
    name                VARCHAR(256)    NOT NULL,
    
    PRIMARY KEY (file_id)
);


CREATE TABLE classes (
    class_id			INTEGER         NOT NULL AUTO_INCREMENT,
    name				VARCHAR(256)    NOT NULL,
    
    PRIMARY KEY (class_id)
);

#####
# Users table contains information about the users
#####

CREATE TABLE roles (
    role_id             INTEGER         NOT NULL AUTO_INCREMENT,
    name                VARCHAR(32)     NOT NULL,
    description         TEXT(4096)      NOT NULL,
    
    PRIMARY KEY (role_id)
);

CREATE TABLE users (
    user_id             INTEGER         NOT NULL AUTO_INCREMENT,
    username            VARCHAR(32)     NOT NULL,
    password            CHAR(40)        NOT NULL,
    first_name          VARCHAR(64)     NOT NULL,
    last_name           VARCHAR(64)     NOT NULL,
    country_id          INTEGER         NOT NULL,
    email               VARCHAR(128)    NOT NULL,
    city                VARCHAR(64)     NOT NULL,
    address             TEXT(1024)      NOT NULL,
    telephone           VARCHAR(64)     NOT NULL,
    school              VARCHAR(128)    NOT NULL,

    PRIMARY KEY (user_id),

    CONSTRAINT FK_users_countries
        FOREIGN KEY FK_users_countries (country_id)
            REFERENCES countries(country_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT
);

CREATE TABLE roles_users (
    role_id             INTEGER         NOT NULL,
    user_id             INTEGER         NOT NULL,
    
    CONSTRAINT FK_roles_users_roles
        FOREIGN KEY FK_roles_users_roles (role_id)
            REFERENCES roles(role_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,

    CONSTRAINT FK_roles_users_users
        FOREIGN KEY FK_roles_users_users (user_id)
            REFERENCES users(user_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT            
);

################################################################################
# Articles tables
# Articles table contains information about articles.
#####

CREATE TABLE articles (
	article_id			INTEGER			NOT NULL AUTO_INCREMENT,
	name				VARCHAR(32)		NOT NULL,
	title				VARCHAR(256)	NOT NULL,
	owner_id			INTEGER			NOT NULL,
	article_type		INTEGER			NOT NULL,
	
	PRIMARY KEY (article_id),
	
	CONSTRAINT FK_articles_owners
		FOREIGN KEY FK_articles_owners (owner_id)
			REFERENCES users(user_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);

#####
# Articles_contents table contains the content of articles is different languages
#####

CREATE TABLE article_contents (
    article_content_id  INTEGER         NOT NULL AUTO_INCREMENT,
    article_id          INTEGER         NOT NULL,
    language_id         INTEGER         NOT NULL,
    content             TEXT(65536)     NOT NULL,

    PRIMARY KEY (article_content_id),

    CONSTRAINT FK_article_contents_articles
        FOREIGN KEY FK_article_contents_articles (article_id)
            REFERENCES articles(article_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,

    CONSTRAINT FK_article_contents_languages
        FOREIGN KEY FK_article_contents_languages (language_id)
            REFERENCES languages(language_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT
);

#####
# Articles_files table contains the files accosiated with given article
#####

CREATE TABLE articles_files (
    id                  INTEGER         NOT NULL AUTO_INCREMENT,
    article_id          INTEGER         NOT NULL,
    file_id             INTEGER         NOT NULL,
    
    PRIMARY KEY (id),
    
    CONSTRAINT FK_articles_files_articles
        FOREIGN KEY FK_articles_files_articles (article_id)
            REFERENCES articles(article_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,
    
    CONSTRAINT FK_articles_files_files
        FOREIGN KEY FK_articles_files_files (file_id)
            REFERENCES files(file_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT
);

#####
# Articles_classes table gives relation many to many between articles and classes
#####

CREATE TABLE articles_classes (
	id					INTEGER			NOT NULL AUTO_INCREMENT,
	article_id			INTEGER			NOT NULL,
	class_id			INTEGER			NOT NULL,
	
	PRIMARY KEY (id),
	
	CONSTRAINT FK_articles_classes_articles
		FOREIGN KEY FK_articles_classes_articles (article_id)
			REFERENCES articles(article_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
			
	CONSTRAINT FK_articles_classes_classes
		FOREIGN KEY FK_articles_classes_classes (class_id)
			REFERENCES classes(class_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);

#####
# Articles_privilages table contains infomation which users have rights to change given article
################################################################################

CREATE TABLE articles_privileges (
	id					INTEGER			NOT NULL AUTO_INCREMENT,
	article_id			INTEGER			NOT NULL,
	user_id				INTEGER			NOT NULL,
	
	PRIMARY KEY (id),
	
	CONSTRAINT FK_articles_privileges_articles
		FOREIGN KEY FK_articles_privileges_articles (article_id)
			REFERENCES articles(article_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
			
	CONSTRAINT FK_articles_privileges_users
		FOREIGN KEY FK_articles_privileges_users (user_id)
			REFERENCES users(user_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);

################################################################################
# Tasks TABLES
# Tasks table contains information about tasks.
#####

CREATE TABLE tasks (
	task_id				INTEGER			NOT NULL AUTO_INCREMENT,
	name				VARCHAR(32)		NOT NULL,
	title				VARCHAR(256)	NOT NULL,
	owner_id			INTEGER			NOT NULL,
	task_type			INTEGER			NOT NULL,
	difficulty			INTEGER			NOT NULL,
	
	PRIMARY KEY (task_id),
	
	CONSTRAINT FK_tasks_owners
		FOREIGN KEY FK_tasks_owners (owner_id)
			REFERENCES users(user_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);

#####
# Task_contents table contains the content of a task in different languages
#####

CREATE TABLE task_contents (
    task_content_id     INTEGER         NOT NULL AUTO_INCREMENT,
    task_id             INTEGER         NOT NULL,
    language_id         INTEGER         NOT NULL,
    content             TEXT(65536)     NOT NULL,

    PRIMARY KEY (task_content_id),

    CONSTRAINT FK_task_contents_tasks
        FOREIGN KEY FK_task_contents_tasks (task_id)
            REFERENCES tasks(task_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,

    CONSTRAINT FK_task_contents_languages
        FOREIGN KEY FK_task_contents_languages (language_id)
            REFERENCES languages(language_id)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT
);

#####
# Tasks_classes table gives relation many to many between tasks and classes
#####

CREATE TABLE tasks_classes (
	id					INTEGER			NOT NULL AUTO_INCREMENT,
	task_id				INTEGER			NOT NULL,
	class_id			INTEGER			NOT NULL,
	
	PRIMARY KEY (id),
	
	CONSTRAINT FK_tasks_classes_tasks
		FOREIGN KEY FK_tasks_classes_tasks (task_id)
			REFERENCES tasks(task_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
			
	CONSTRAINT FK_tasks_classes_classes
		FOREIGN KEY FK_tasks_classes_classes (class_id)
			REFERENCES classes(class_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);


CREATE TABLE tests (
	test_id				INTEGER			NOT NULL AUTO_INCREMENT,
	number				INTEGER			NOT NULL,
	task_id				INTEGER			NOT NULL,
	
	PRIMARY KEY (test_id),
		
	CONSTRAINT FK_tests_tasks
		FOREIGN KEY FK_tests_tasks (task_id)
			REFERENCES tasks(task_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);

CREATE TABLE tests_files (
  test_file_id            INTEGER     NOT NULL AUTO_INCREMENT,
  test_id       INTEGER     NOT NULL,
  file_id       INTEGER     NOT NULL,
  test_type     INTEGER     NOT NULL,

  PRIMARY KEY (test_file_id),

  CONSTRAINT FK_tests_files_files
		FOREIGN KEY FK_tests_files_files (file_id)
			REFERENCES files(file_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,

  CONSTRAINT FK_tests_files_tests
		FOREIGN KEY FK_tests_files_tests (test_id)
			REFERENCES tests(test_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);



CREATE TABLE modules (
	module_id			INTEGER			NOT NULL AUTO_INCREMENT,
	name				VARCHAR(256)	NOT NULL,
	task_id				INTEGER			NOT NULL,
	
	PRIMARY KEY (module_id),
	
	CONSTRAINT FK_modules_tasks
		FOREIGN KEY FK_modules_tasks (task_id)
			REFERENCES tasks(task_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);


CREATE TABLE modules_files (
    module_file_id                  INTEGER     NOT NULL AUTO_INCREMENT,
    module_id           INTEGER     NOT NULL,
    file_id             INTEGER     NOT NULL,
    module_type           INTEGER     NOT NULL,
    PRIMARY KEY (module_file_id),

  CONSTRAINT FK_modules_files_files
		FOREIGN KEY FK_modules_files_files (file_id)
			REFERENCES files(file_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,

  CONSTRAINT FK_modules_files_modules
		FOREIGN KEY FK_modules_files_modules (module_id)
			REFERENCES modules(module_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);

CREATE TABLE program_languages (
    program_language_id             INTEGER         NOT NULL AUTO_INCREMENT,
    name                VARCHAR(256)    NOT NULL,
    
    PRIMARY KEY (program_language_id)
);


CREATE TABLE compiler_options (
    compiler_option_id  INTEGER         NOT NULL AUTO_INCREMENT,
    command_line        VARCHAR(2048)   NOT NULL,
    time_limit          INTEGER         NOT NULL,
    program_language_id             INTEGER         NOT NULL,
    
    PRIMARY KEY (compiler_option_id),
    
    CONSTRAINT FK_compiler_options_program_languages
		FOREIGN KEY FK_compiler_options_program_languages (program_language_id)
			REFERENCES	program_languages(program_language_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);

CREATE TABLE checkers (
	checker_id			INTEGER			NOT NULL AUTO_INCREMENT,
	name				VARCHAR(256)	NOT NULL,
	file_id				INTEGER			NOT NULL,
	task_id				INTEGER			NOT NULL,
	program_language_id INTEGER         NOT NULL,
	
	PRIMARY KEY (checker_id),
	
	CONSTRAINT FK_checkers_files
		FOREIGN KEY FK_checkers_files (file_id)
			REFERENCES files(file_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
	
	CONSTRAINT FK_checkers_tasks
		FOREIGN KEY FK_checkers_tasks (task_id)
			REFERENCES tasks(task_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
			
	CONSTRAINT FK_checkers_program_languages
		FOREIGN KEY FK_checkers_program_languages (program_language_id)
			REFERENCES program_languages(program_language_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);


CREATE TABLE sample_solutions (
	sample_solution_id	INTEGER			NOT NULL AUTO_INCREMENT,
	name				VARCHAR(256)	NOT NULL,
	file_id				INTEGER			NOT NULL,
	task_id				INTEGER			NOT NULL,
	
	PRIMARY KEY (sample_solution_id),
	
	CONSTRAINT FK_sample_solutions_files
		FOREIGN KEY FK_sample_solutions_files (file_id)
			REFERENCES files(file_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
	
	CONSTRAINT FK_sample_solutions_tasks
		FOREIGN KEY FK_sample_solutions_tasks (task_id)
			REFERENCES tasks(task_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);


CREATE TABLE restrictions (
	restriction_id		INTEGER			NOT NULL AUTO_INCREMENT,
	task_id				INTEGER			NOT NULL,
	runtime				INTEGER			NOT NULL,
	memory				INTEGER			NOT NULL,
	stack_size			INTEGER			NOT NULL,
	source_code			INTEGER			NOT NULL,
	output_size			INTEGER			NOT NULL,
	compilation_time	INTEGER			NOT NULL,
	
	PRIMARY KEY (restriction_id),
	
	CONSTRAINT FK_restrictions_tasks
		FOREIGN KEY FK_restrictions_tasks (task_id)
			REFERENCES tasks(task_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);


CREATE TABLE tasks_privileges (
	id					INTEGER			NOT NULL AUTO_INCREMENT,
	user_id				INTEGER			NOT NULL,
	task_id				INTEGER			NOT NULL,
	
	PRIMARY KEY (id),
	
	CONSTRAINT FK_tasks_privileges_users
		FOREIGN KEY FK_tasks_privileges_users (user_id)
			REFERENCES	users(user_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
	
	CONSTRAINT FK_tasks_privileges_tasks
		FOREIGN KEY FK_tasks_privileges_tasks (task_id)
			REFERENCES	tasks(task_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);



CREATE TABLE submits (
	submit_id			INTEGER			NOT NULL AUTO_INCREMENT,
	user_id				INTEGER			NOT NULL,
	file_id				INTEGER			NOT NULL,
	task_id				INTEGER			NOT NULL,
	program_language_id INTEGER         NOT NULL,
	submit_at			TIMESTAMP		NOT NULL,
	
	PRIMARY KEY (submit_id),
	
	CONSTRAINT FK_submits_users
		FOREIGN KEY FK_submits_users (user_id)
			REFERENCES users(user_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
			
	CONSTRAINT FK_submits_files
		FOREIGN KEY FK_submits_files (file_id)
			REFERENCES files(file_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
	
	CONSTRAINT FK_submits_tasks
		FOREIGN KEY FK_submits_tasks (task_id)
			REFERENCES tasks(task_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
			
	CONSTRAINT FK_submits_program_languages
		FOREIGN KEY FK_submits_program_languages (program_language_id)
			REFERENCES program_languages(program_language_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);





CREATE TABLE checker_responses (
    checker_response_id         INTEGER         NOT NULL AUTO_INCREMENT,
    status                      INTEGER         NOT NULL,
    message                     VARCHAR(2048)   NOT NULL,
    correctness                 DOUBLE          NOT NULL,
    user_time                   INTEGER         NOT NULL,
    system_time                 INTEGER         NOT NULL,
    exit_status                 INTEGER         NOT NULL,
    term_sig                    INTEGER,
    
    PRIMARY KEY (checker_response_id)
);




CREATE TABLE compiler_responses (
    compiler_response_id        INTEGER         NOT NULL AUTO_INCREMENT,
    status                      INTEGER         NOT NULL,
    message                     VARCHAR(256)    NOT NULL,
    compiler_output             VARCHAR(2048)   NOT NULL,
    user_time                   INTEGER         NOT NULL,
    system_time                 INTEGER         NOT NULL,
    exit_status                 INTEGER         NOT NULL,
    term_sig                    INTEGER,
    
    PRIMARY KEY (compiler_response_id)
   
);



CREATE TABLE grader_responses (
	grader_response_id                 INTEGER         NOT NULL AUTO_INCREMENT,
	submit_id                          INTEGER         NOT NULL,
	module_id                          INTEGER         NOT NULL,
	checker_id                         INTEGER         NOT NULL,
	solution_compiler_response_id      INTEGER         NOT NULL,
	checker_compiler_response_id       INTEGER         NOT NULL,
	message                            TEXT(2048)      NOT NULL,
	status                             INTEGER         NOT NULL,
	
	PRIMARY KEY (grader_response_id),
	
	CONSTRAINT FK_grader_responses_submits
		FOREIGN KEY FK_grader_responses_submits (submit_id)
			REFERENCES submits(submit_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
	
	CONSTRAINT FK_grader_responses_modules
		FOREIGN KEY FK_grader_responses_modules (module_id)
			REFERENCES modules(module_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
	
    CONSTRAINT FK_grader_responses_checkers
		FOREIGN KEY FK_grader_responses_checkers (checker_id)
			REFERENCES checkers(checker_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
			
	CONSTRAINT FK_grader_responses_compiler_responses1
		FOREIGN KEY FK_grader_responses_compiler_responses1 (solution_compiler_response_id)
			REFERENCES compiler_responses (compiler_response_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
	
	CONSTRAINT FK_grader_responses_compiler_responses2
		FOREIGN KEY FK_grader_responses_compiler_responses2 (checker_compiler_response_id)
			REFERENCES compiler_responses (compiler_response_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);


CREATE TABLE test_responses (
    test_response_id            INTEGER         NOT NULL AUTO_INCREMENT,
    grader_response_id          INTEGER         NOT NULL,
    checker_response_id         INTEGER         NOT NULL,
    test_id                     INTEGER         NOT NULL,
    status                      INTEGER         NOT NULL,
    message                     VARCHAR(256)    NOT NULL,
    user_time                   INTEGER         NOT NULL,
    system_time                 INTEGER         NOT NULL,
    memory_usage                INTEGER         NOT NULL,
    exit_status                 INTEGER         NOT NULL,
    term_sig                    INTEGER,
    
    PRIMARY KEY (test_response_id),
    
    CONSTRAINT FK_test_responses_grader_responses
		FOREIGN KEY FK_test_responses_grader_responses (grader_response_id)
			REFERENCES grader_responses(grader_response_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
    
    CONSTRAINT FK_test_responses_checker_responses
		FOREIGN KEY FK_test_responses_checker_responses (checker_response_id)
			REFERENCES checker_responses(checker_response_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
			
    CONSTRAINT FK_test_responses_tests
		FOREIGN KEY FK_test_responses_tests (test_id)
			REFERENCES tests(test_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);




CREATE TABLE board_types (
	board_type_id		INTEGER			NOT NULL AUTO_INCREMENT,
	name				VARCHAR(256)	NOT NULL,
	
	PRIMARY KEY (board_type_id)
);


CREATE TABLE contest_types (
	contest_type_id		INTEGER			NOT NULL AUTO_INCREMENT,
	name				VARCHAR(256)	NOT NULL,
	
	PRIMARY KEY (contest_type_id)
);


CREATE TABLE contests (
	contest_id			INTEGER			NOT NULL AUTO_INCREMENT,
	name				VARCHAR(256)	NOT NULL,
	title				VARCHAR(1024)	NOT NULL,
	start_time			TIMESTAMP		NOT NULL,
	end_time			TIMESTAMP		NOT NULL,
	duration			TIME			        ,
	board_type_id		INTEGER			NOT NULL,
	contest_type_id		INTEGER			NOT NULL,
	is_private			BOOL			NOT NULL,
	owner_id			INTEGER			NOT NULL,
	
	PRIMARY KEY (contest_id),
	
	CONSTRAINT FK_contests_board_types
		FOREIGN KEY FK_contests_board_types (board_type_id)
			REFERENCES board_types(board_type_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
	
	CONSTRAINT FK_contest_contest_types
		FOREIGN KEY FK_contests_contest_types (contest_type_id)
			REFERENCES contest_types(contest_type_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
			
	CONSTRAINT FK_contests_owners
		FOREIGN KEY FK_contests_owners (owner_id)
			REFERENCES users(user_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);


CREATE TABLE contests_submits (
	id					INTEGER			NOT NULL AUTO_INCREMENT,
	contest_id			INTEGER			NOT NULL,
	submit_id			INTEGER			NOT NULL,
	
	PRIMARY KEY (id),
	
	CONSTRAINT FK_contest_submits_contests
		FOREIGN KEY FK_contest_submits_contests (contest_id)
			REFERENCES contests(contest_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
	
	CONSTRAINT FK_contest_submits_submits
		FOREIGN KEY FK_contest_submits_submits (submit_id)
			REFERENCES submits(submit_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);


CREATE TABLE contests_tasks (
	id                     INTEGER         NOT NULL AUTO_INCREMENT,
	contest_id             INTEGER         NOT NULL,
	task_id                INTEGER         NOT NULL,
    restriction_id         INTEGER         NOT NULL,	
	number                 INTEGER         NOT NULL,	
		
	PRIMARY KEY (id),
	
	CONSTRAINT FK_contests_tasks_contests
		FOREIGN KEY FK_contests_tasks_contests (contest_id)
			REFERENCES contests(contest_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
	
	CONSTRAINT FK_contests_tasks_tasks
		FOREIGN KEY FK_contests_tasks_tasks (task_id)
			REFERENCES tasks(task_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
    
	CONSTRAINT FK_contests_tasks_restrictions
		FOREIGN KEY FK_contests_tasks_restrictions (restriction_id)
			REFERENCES restrictions(restriction_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
			
);


CREATE TABLE contest_privileges (
	id					INTEGER			NOT NULL AUTO_INCREMENT,
	contest_id			INTEGER			NOT NULL,
	user_id				INTEGER			NOT NULL,
	judge				BOOL			NOT NULL,
	register			BOOL			NOT NULL,
	compete				BOOL			NOT NULL,
	
	PRIMARY KEY (id),
	
	CONSTRAINT FK_contest_privileges_contests
		FOREIGN KEY FK_contest_privileges_contests (contest_id)
			REFERENCES contests(contest_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
	
	CONSTRAINT FK_contest_privileges_users
		FOREIGN KEY FK_contest_privileges_users (user_id)
			REFERENCES users(user_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);


CREATE TABLE contests_modules (
    contest_module_id           INTEGER         NOT NULL AUTO_INCREMENT,
    contest_id                  INTEGER         NOT NULL,
    module_id                   INTEGER         NOT NULL,
    task_id                     INTEGER         NOT NULL,
    action                      INTEGER         NOT NULL,
    program_language_id         INTEGER         NOT NULL,
    
    PRIMARY KEY (contest_module_id),
    
    CONSTRAINT FK_contests_modules_contests
		FOREIGN KEY FK_contests_modules_contests (contest_id)
			REFERENCES contests(contest_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,

    CONSTRAINT FK_contests_modules_modules
		FOREIGN KEY FK_contests_modules_modules (module_id)
			REFERENCES modules(module_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
			
    CONSTRAINT FK_contests_modules_tasks
		FOREIGN KEY FK_contests_modules_tasks (task_id)
			REFERENCES tasks(task_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,

    CONSTRAINT FK_contests_modules_program_languages
		FOREIGN KEY FK_contests_modules_program_languages (program_language_id)
			REFERENCES program_languages(program_language_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);


CREATE TABLE contests_checkers (
    contest_checker_id          INTEGER         NOT NULL AUTO_INCREMENT,
    contest_id                  INTEGER         NOT NULL,
    checker_id                  INTEGER         NOT NULL,
    task_id                     INTEGER         NOT NULL,
    action                      INTEGER         NOT NULL,
    
    PRIMARY KEY (contest_checker_id),
    
    CONSTRAINT FK_contests_checkers_contests
		FOREIGN KEY FK_contests_checkers_contests (contest_id)
			REFERENCES contests(contest_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,

    CONSTRAINT FK_contests_checkers_checkers
		FOREIGN KEY FK_contests_checkers_checkers (checker_id)
			REFERENCES checkers(checker_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT,
	
	CONSTRAINT FK_contests_checkers_tasks
		FOREIGN KEY FK_contests_checkers_tasks (task_id)
			REFERENCES tasks(task_id)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT
);

