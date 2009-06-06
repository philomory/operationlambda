require 'enumerator'

require 'helper'

module OperationLambda
  class Levelset
    module BoardData

      Pack      = 'v*'
      Bytes     = [0].pack(Pack).length
      RowLength = Sizes::TilesWide * Bytes
      BoardSize = Sizes::TilesHigh * RowLength

      def level_for_data(data)
        level = {}
        short_data = data.unpack(Pack)
        bcd_time = short_data.pop # bcd == Binary Coded Decimal
        minutes = bcd_time/256
        seconds = (bcd_time%256).to_s(16).to_i
        level[:time] = minutes*60 + seconds
        level[:places] = short_data.map{|datum| DataToKeyHash[datum]}.enum_slice(Sizes::TilesWide).to_a.transpose
        return level
      end
      
      def data_for_level(level)
        short_data = level[:places].transpose.flatten.map {|key| KeyToDataHash[key]}
        seconds = level[:time] % 60
        minutes = level[:time] / 60
        bcd_time = (minutes * 256) + ("0x#{seconds}").to_i
        short_data.push(bcd_time)
        data = short_data.pack(Pack)
      end
      
      
      DataToKeyHash = {
        0x0000 => 'Space',                   
        0x0001 => 'Empty',                  

        0x0010 => 'Player-west',
        0x0012 => 'Player-east',            
        0x0014 => 'Player-north',             
        0x0016 => 'Player-south',            
        0x0020 => 'Hostage-west',            
        0x0022 => 'Hostage-east',            
        0x0024 => 'Hostage-north',           
        0x0026 => 'Hostage-south',           

        0x1180 => 'Mirror-normal',           
        0x1280 => 'Mirror-flipped',          

        0x4000 => 'PushableBrick',           
        0x5000 => 'Bomb',          
        0x7000 => 'EscapeHatch',             

        0x9000 => 'Brick',            
        0xa000 => 'CrackedBrick',            

        0x9100 => 'CornerSE',                
        0x9200 => 'CornerNE',                
        0xd100 => 'CornerNW',               
        0xd200 => 'CornerSW',               

        0xb400 => 'Generator-blue-on',       
        0xb800 => 'Generator-red-on',      
        0xbc00 => 'Generator-purple-on',     

        0x9400 => 'Laser-blue-west-on',    
        0x9402 => 'Laser-blue-east-on',     
        0x9404 => 'Laser-blue-north-on',     
        0x9406 => 'Laser-blue-south-on',    
        0x9800 => 'Laser-red-west-on',    
        0x9802 => 'Laser-red-east-on',      
        0x9804 => 'Laser-red-north-on',      
        0x9806 => 'Laser-red-south-on',     
        0x9c00 => 'Laser-purple-west-on',    
        0x9c02 => 'Laser-purple-east-on',   
        0x9c04 => 'Laser-purple-north-on',   
        0x9c06 => 'Laser-purple-south-on',  

        0xe400 => 'Switch-blue-vertical',    
        0xe404 => 'Switch-blue-horizontal',  
        0xe800 => 'Switch-red-vertical',
        0xe804 => 'Switch-red-horizontal',   
        0xec00 => 'Switch-purple-vertical',  
        0xec04 => 'Switch-purple-horizontal',

        0xf400 => 'Frame-blue-west-closed',
        0xf402 => 'Frame-blue-east-closed',        
        0xf404 => 'Frame-blue-north-closed',        
        0xf406 => 'Frame-blue-south-closed',       
        0xf408 => 'Gate-blue-horizontal',    
        0xf40c => 'Gate-blue-vertical',   

        0xf800 => 'Frame-red-west-closed',     
        0xf802 => 'Frame-red-east-closed',         
        0xf804 => 'Frame-red-north-closed',         
        0xf806 => 'Frame-red-south-closed',         
        0xf808 => 'Gate-red-horizontal',     
        0xf80c => 'Gate-red-vertical',    

        0xfc00 => 'Frame-purple-west-closed',       
        0xfc02 => 'Frame-purple-east-closed',       
        0xfc04 => 'Frame-purple-north-closed',      
        0xfc06 => 'Frame-purple-south-closed',      
        0xfc08 => 'Gate-purple-horizontal',  
        0xfc0c => 'Gate-purple-vertical'
      }
      
      KeyToDataHash = DataToKeyHash.invert
      KeyToDataHash.default_proc=(lambda{|h,key| raise "No match for key '#{key}' in BoardData::KeyToDataHash"})
      
      DataToKeyHash.default_proc=(lambda{|h,key| raise "No match for key '#{key}' in BoardData::DataToKeyHash"})
      
    end #module BoardData
  end #class Levelset
end #module OperationLambda