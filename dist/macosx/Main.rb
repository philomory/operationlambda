module OperationLambda
  module Platform
    TopDir = File.dirname(__FILE__)
    AppSrcDir = File.join(TopDir,'app')
    LibSrcDir = File.join(TopDir,'lib')
    ApplicationDir = File.join(TopDir,'appdata')
    UserDir = File.join(ENV['HOME'],'Library','Application Support','Operation Lambda')
  end
end

$LOAD_PATH.replace([OperationLambda::Platform::AppSrcDir,OperationLambda::Platform::LibSrcDir])

require 'MainWindow'

OperationLambda::Platform.setup_userdir
OperationLambda::Settings.load_settings
$window = OperationLambda::MainWindow.instance
$window.show
