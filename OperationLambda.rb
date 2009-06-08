#!/usr/bin/env ruby
begin
module OperationLambda
  module Platform
    TopDir = File.dirname(__FILE__)
    AppSrcDir = File.join(TopDir,'app')
    LibSrcDir = File.join(TopDir,'lib')
    ApplicationDir = File.join(TopDir,'appdata')
    UserDir = File.join(TopDir,'userdata')
  end
end

$LOAD_PATH.push(OperationLambda::Platform::LibSrcDir)
$LOAD_PATH.push(OperationLambda::Platform::AppSrcDir)

require 'MainWindow'
OperationLambda::Platform.setup_userdir
OperationLambda::Settings.load_settings
$window = OperationLambda::MainWindow.instance
$window.show
rescue
puts $!
puts $!.backtrace
gets
end