require 'soap/rpc/driver'
require 'pcs/test_response'
require 'pcs/grader_response'
require 'pcs/compiler_response'


server = SOAP::RPC::Driver.new("http://localhost:5000", "urn:PCS/Grader");

server.add_method('test', 'problem_id', 'submit_id', 'test_id', 'checker_id', 'module_id')

grader_response = server.test(1,1,1,1,1)
puts grader_response.class
puts grader_response.test_responses[0].class
puts grader_response.test_responses[0].status
puts grader_response.test_responses[0].message
puts grader_response.solution_compiler_response.message
puts grader_response.checker_compiler_response.message
puts grader_response.test_responses[0].checker_response.status
puts grader_response.test_responses[0].checker_response.message

