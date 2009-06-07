module OperationLambda
  module Platform
    SourceDir = File.dirname(__FILE__) unless defined? SourceDir
    TopDir = File.dirname(SourceDir) unless defined? TopDir
    ApplicationDir = File.join(TopDir,'appdata') unless defined? ApplicationDir
    UserDir = File.join(TopDir,'userdata') unless defined? UserDir
    SettingsDir = UserDir unless defined? SettingsDir
    SettingsFile = File.join(SettingsDir,"settings.yaml") unless defined? SettingsFile
    ApplicationMediaDir = File.join(ApplicationDir,"media") unless defined? ApplicationMediaDir
    ApplicationImagesDir = File.join(ApplicationMediaDir,"images") unless defined? ApplicationImagesDir
    ApplicationFontDir = File.join(ApplicationMediaDir,"fonts") unless defined? ApplicationFontDir
    ApplicationTilesetDir = File.join(ApplicationImagesDir,"tiles") unless defined? ApplicationTilesetDir
    ApplicationLevelsetsDir = File.join(ApplicationDir,"levelsets") unless defined? ApplicationLevelsetDir
    UserMediaDir = File.join(UserDir,"media") unless defined? UserMediaDir
    UserTilesetDir = File.join(UserMediaDir,"tiles") unless defined? UserTilesetDir
    UserLevelsetsDir = File.join(UserDir,"levelsets") unless defined? UserLevelsetsDir
  
  
    module_function
    def setup_userdir
      [UserDir,SettingsDir,UserMediaDir,UserTilesetDir,UserLevelsetsDir].each do |dir|
        Dir.mkdir(dir) unless File.exist?(dir)
      end
    end
  end
end