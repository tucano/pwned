namespace :utils do
  namespace :storage do

    desc "Create a storage"
    task :init => :environment do
      storage = "#{RAILS_ROOT}/#{STORAGE_PATH_PREFIX}"
      if File.exists?(storage) then
        puts "#{storage} already exists. You can delete the storage with utils:storage:drop"
      else
        puts "Creating #{storage}"
        Dir.mkdir(storage)
      end
    end

    desc "Delete the storage and ALL files!"
    task :drop => :environment do
      storage = "#{RAILS_ROOT}/#{STORAGE_PATH_PREFIX}"
      if File.exists?(storage) then
        puts "Deleting #{storage}"
        FileUtils.rm_rf(storage)
      else
        puts "#{storage} doesn't exists"
      end
    end

  end
end

task :test do
  
end
