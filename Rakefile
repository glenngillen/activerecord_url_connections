require "bundler"
require "rake"
require "rake/testtask"
module ActiveRecordURLConnections
  class RakeTasks
    include Rake::DSL
    Rake::TestTask.new do |t|
      t.libs << "test"
      t.test_files = FileList["test/*_test.rb"]
      t.verbose = true
    end
  end
end
Bundler::GemHelper.install_tasks
