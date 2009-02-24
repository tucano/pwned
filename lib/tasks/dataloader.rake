namespace :utils do
  namespace :storage do

    desc "Create a storage"
    task :init do
      storage = "#{RAILS_ROOT}/public/storage"
      if File.exists?(storage) then
        puts "#{storage} already exists. You can delete the storage with utils:storage:drop"
      else
        puts "Creating #{storage}"
        Dir.mkdir(storage)
      end
    end

    desc "Delete the storage and ALL files!"
    task :drop do
      storage = "#{RAILS_ROOT}/public/storage"
      if File.exists?(storage) then
        puts "Deleting #{storage}"
        FileUtils.rm_rf(storage)
      else
        puts "#{storage} doesn't exists"
      end
    end

    desc "Copy fixture files from test/fixtures/storage dir in public/storage"
    task :load do
      testdata = "#{RAILS_ROOT}/test/fixtures/storage/."
      storage = "#{RAILS_ROOT}/public/storage/"
      puts "Copying fixtures files from #{testdata} to #{storage}"
      FileUtils.cp_r(testdata,storage)
    end

  end
end
