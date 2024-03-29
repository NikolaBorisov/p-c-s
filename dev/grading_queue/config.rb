#
# Configuration options
#

require 'logger'


#
# WebService Server configuration
#
server.app_name = 'GradingQueue'
server.namespace = 'urn:PCS/GradingQueue'
server.address = '0.0.0.0'
server.port = 5004
server.logging_level = Logger::INFO

queue.db_settings = {
  :adapter  => 'mysql',
  :host     => 'localhost',
  :port     => '3306',
  :database => 'pcs',
  :username => 'pcs',
  :password => '1234'
}

# GradingQueue Retry Settings
queue.times_to_retry = 5
queue.sleep_on_retry = 0.5   # sek

# GradingQueue Logger Settings
queue.logger_shift_age = 5
queue.logger_shift_size = 10 * 1024
queue.logging_level = Logger::INFO
queue.logger_datetime_format = '%Y.%m.%d %H:%M:%S'
queue.grading_queue_root = '/home/contest/grading_queue'
