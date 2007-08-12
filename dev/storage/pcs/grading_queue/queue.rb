require 'monitor'

module PCS
  module GradingQueue
    
    
    
    class Queue
      
      def initialize
        @queue = {}
        @start_index = 0
        @end_index = 0
        @monitor = Monitor.new
      end
      
      
      def size
        return @end_index-@start_index
      end
      
      
      def empty?
       (@end_index-@start_index == 0)
      end
      
      
      def push(job)
        @monitor.synchronize do
          @queue[@end_index] = job
          @end_index += 1
        end
      end
      
      
      def top
        @monitor.synchronize do
          return @queue[@start_index]
        end
      end
      
      
      def pop
        @monitor.synchronize do
          job = @queue[@start_index]
          @queue.delete(@start_index)
          @start_index += 1
          return job
        end
      end
      
      
      def include?(job)
        @queue.has_value(job)
      end
      
      
      def get_all_jobs
        @monitor.synchronize do
          jobs = []
          @start_index.upto(@end_index-1) do |x|
            jobs << @queue[x]
          end
          return jobs
        end
      end
      
      
    end    
    
    
    
  end
end