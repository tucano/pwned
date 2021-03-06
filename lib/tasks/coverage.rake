# Conditional require rcov/rcovtask if present
begin
  require 'rcov/rcovtask'

  namespace :test do
  
    namespace :coverage do
      desc "Delete aggregate coverage data."
      task(:clean) do
        rm_rf "test/coverage"
        rm_f "test/coverage.data"
      end
    end
  
    test_types = %w[unit functional integration]
    desc 'Aggregate code coverage for unit, functional and integration tests'
    task :coverage => "test:coverage:clean"
    tests_to_run = test_types.select do |type|
      FileList["test/#{type}/**/*_test.rb"].size > 0
    end
  
    tests_to_run.each do |target|
      namespace :coverage do
        Rcov::RcovTask.new(target) do |t|
          t.libs << "test"
          t.test_files = FileList["test/#{target}/**/*_test.rb"]
          t.verbose = true
          t.rcov_opts << '--rails --aggregate test/coverage.data --exclude /Library/,/System/,/Users/'
          if target == tests_to_run[-1]
            t.output_dir = "test/coverage"
          else
            t.rcov_opts << '--no-html'
          end
        end
      end
      task :coverage => "test:coverage:#{target}"
    end
  
  end
  
rescue Exception
  
end

