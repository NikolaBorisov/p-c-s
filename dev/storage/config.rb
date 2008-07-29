#
# Configuration options
#

require 'logger'


#
# Server configuration
#
server.app_name = 'Storage'
server.namespace = 'urn:PCS/Storage'
server.address = '0.0.0.0'
server.port = 5002
server.logging_level = Logger::INFO

storage.db_settings = {
  :adapter  => 'mysql',
  :host     => 'acm.cs.northwestern.edu',
  :port     => '3306',
  :database => 'pcs',
  :username => 'pcs',
  :password => '1234'
}

# Specify the server and the machine where the FileServer runs. Leave '' if running on this machine
storage.file_server_location = ''
# Storage Retry Settings
storage.times_to_retry = 5
storage.sleep_on_retry = 0.5   # sek

# Storage Logger Settings
storage.logger_shift_age = 5
storage.logger_shift_size = 10 * 1024
storage.logging_level = Logger::INFO
storage.logger_datetime_format = '%Y.%m.%d %H:%M:%S'

