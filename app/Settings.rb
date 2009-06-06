require 'YAML'
require 'Platform'
require 'gosu'

module OperationLambda
  module Settings
    DEFAULTS = { :levelset=>{:dir=>"OperationLambda",:cat=>:app},
                 :level=>1,:music=>true,:volume=>10,
                 :tileset=>{:dir=>"OperationLambda",:cat=>:app},
                 :show_previews=>true,:fullscreen=>false,:use_fonts=>true,
                 :key_config => {
                   :gameplay => {
                     Gosu::KbUp =>    :north,
                     Gosu::KbDown =>  :south,
                     Gosu::KbRight => :east,
                     Gosu::KbLeft =>  :west,
                     Gosu::KbZ =>     :shoot,
                     Gosu::KbX =>     :rotate
                   },
                   :editor => {
                     Gosu::KbUp =>     :north,
                     Gosu::KbDown =>   :south,
                     Gosu::KbRight =>  :east,
                     Gosu::KbLeft =>   :west,
                     Gosu::KbSpace =>  :place,
                     Gosu::KbDelete => :erase,
                     Gosu::KbZ =>      :toggle_auto,
                     Gosu::KbX =>      :rotate,
                     Gosu::KbC =>      :color
                   }
                 }
               }
    SETTINGS = DEFAULTS.dup
    
    module_function
    
    def load_settings
      begin
        SETTINGS.merge!(YAML.load_file(Platform::SettingsFile))
      rescue
        save_settings
      end
    end
    
    def save_settings
      File.open(Platform::SettingsFile, 'w' ) do |out|
        YAML.dump(SETTINGS,out)
      end
    end
    
    def load_defaults
      SETTINGS.replace(DEFAULTS)
    end
    
    def listener_for_key(key,listener,method)
      (@listeners ||= []) << {:key=>key,:listener=>listener,:method=>method}
    end
    
    def [](key)
      SETTINGS[key]
    end
    
    def []=(key,value)
      if value != SETTINGS[key]
        SETTINGS[key] = value
      end
    end
        
    private
    def key_changed(key,value)
      @listeners.each do |h|
        if h[:key] = key
          h[:listener].send(:method)
        end
      end
    end
    
        
  end
end