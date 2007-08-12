#!/bin/sh
killall -9 ruby
cd grader
ruby start_grader.rb &
cd ..
cd storage
ruby start_storage.rb &
cd ..
cd grading_queue
ruby start_grading_queue.rb &
cd ..
cd main
ruby script/server
killall -9 ruby

