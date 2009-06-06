module OperationLambda
  module Platform
    #SourceDir = File.dirname(__FILE__)
    #TopDir = File.dirname(SourceDir)
    #ApplicationDir = File.join(TopDir,'appdata')
    #UserDir = File.join(TopDir,'userdata')
    SettingsDir = UserDir
    SettingsFile = File.join(SettingsDir,"settings.yaml")
    ApplicationMediaDir = File.join(ApplicationDir,"media")
    ApplicationImagesDir = File.join(ApplicationMediaDir,"images")
    ApplicationFontDir = File.join(ApplicationMediaDir,"fonts")
    ApplicationTilesetDir = File.join(ApplicationImagesDir,"tiles")
    ApplicationLevelsetsDir = File.join(ApplicationDir,"levelsets")
    UserMediaDir = File.join(UserDir,"media")
    UserTilesetDir = File.join(UserMediaDir,"tiles")
    UserLevelsetsDir = File.join(UserDir,"levelsets")
    
  end
end