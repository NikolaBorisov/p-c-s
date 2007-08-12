#
# Configuration options
# 

require 'logger'



#
# Server configuration
#
server.app_name = 'Grader'
server.namespace = 'urn:PCS/Grader'
server.address = '0.0.0.0'
server.port = 5000
server.logging_level = Logger::INFO



#
# Storage configuration
#
storage.host = 'http://localhost:5002'
storage.namespace = 'urn:PCS/Storage'
storage.times_to_retry = 5
storage.sleep_on_retry = 0.5


#
# Changes the grader root directory. If not set, it will be the same as the
# directory of start_grader.rb
#
#grader.grader_root = '/var/grader'
grader.execute_uid = 1001
grader.user = 'contest'
grader.grader_address = 'judge.openfmi.net'
grader.grader_ssh_port = '2200'
grader.logger_shift_age = 5
grader.logger_shift_size = 10 * 1024
grader.logging_level = Logger::INFO
grader.logger_datetime_format = '%Y.%m.%d %H:%M:%S'
