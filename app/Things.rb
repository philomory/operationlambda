module OperationLambda
  module Things
    module_function 
#    def const_missing(thing)
#      filename = "#{thing}.rb"
#      path = "Things"
#      fullpath = path + filename
#      #if File.exists?("#{path}/#{thing.to_s}.rb")
#        require "#{path}/#{thing.to_s}"
#        klass = const_get(thing)
#        return klass if klass
#        raise "Could not find class Things::Class"
#      #else
#       # raise "Could not find file for Things::#{thing.to_s}"
#     #end
#    end
    def load_things
      [ 'Bomb','Brick','CornerNE','CornerNW','CornerSE','CornerSW',
        'CrackedBrick','Empty','EscapeHatch','Frame','Gate','Generator',
        'Hostage','Laser','Mirror','PushableBrick','Space','Switch'
      ].each {|thing| require "Things/#{thing}"}
    end #def load_things
    
  end
end