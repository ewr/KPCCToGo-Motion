$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'motion-cocoapods'


Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'KPCCToGo'
  app.device_family = [:iphone]
  
  app.frameworks += ["AVFoundation"]
  
  app.pods do
    dependency 'AFNetworking'
  end
end

desc "Clean the vendor build folder"
task :vendorclean => [:clean] do
  sh "rm", "-rf", "vendor/build"
  sh "rm", "-rf", "vendor/Pods"
end

task :run => [:default]
