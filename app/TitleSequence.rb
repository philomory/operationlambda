require 'Sequence'
require 'ImageManager'
require 'Constants'

module OperationLambda
  class TitleSequence < Sequence
    def initialize
      @loop_final = true
      
      ['Interrobang','RTP'].each do |logo|

        subseq(1.0) do |portion|
          ImageManager.image(logo).draw(0,0,ZOrder::Things)
          a = ((1-portion) * 0xFF).floor
          c = (a * 0x01000000)
          self.fill(c)
        end

        subseq(3.0) do |portion|
          ImageManager.image(logo).draw(0,0,ZOrder::Things)
        end

        subseq(1.0) do |portion|
          ImageManager.image(logo).draw(0,0,ZOrder::Things)
          a = (portion * 0xFF).floor
          c = (a * 0x01000000)
          self.fill(c)
        end
      
      end

      a = [ 
        {:lambda=>ImageManager.image('LambdaHaze'),
          :beam=>ImageManager.image('BeamPurple'),
          :color=>0xFF00FF,
          :nextlambda=>ImageManager.image('LambdaWater')},
          
        {:lambda=>ImageManager.image('LambdaWater'),
          :beam=>ImageManager.image('BeamBlue'),
          :color=>0x0000FF,
          :nextlambda=>ImageManager.image('LambdaFire')},
          
        {:lambda=>ImageManager.image('LambdaFire'),
          :beam=>ImageManager.image('BeamRed'),
          :color=>0xFF0000,
          :nextlambda=>ImageManager.image('LambdaHaze')}        
      ]
      a.each do |info|
        subseq(1.33) do |portion|
          info[:lambda].draw(0,0,ZOrder::Things)
          y1 = (portion * (Sizes::WindowHeight/2)).floor
          y2 = Sizes::WindowHeight - y1
          info[:beam].draw(0,y1,ZOrder::Floor)
          info[:beam].draw(0,y2,ZOrder::Floor)
        end
        subseq(0.67) do |portion|
          info[:lambda].draw(0,0,ZOrder::Things)
          info[:beam].draw(0,Sizes::WindowHeight/2,ZOrder::Floor)
          a = (portion * 0xFF).floor
          c = (a * 0x01000000) + info[:color]
          self.fill(c)
        end
        subseq(0.33) do |portion|
          info[:nextlambda].draw(0,0,ZOrder::Things)
          a = ((1-portion) * 0xFF).floor
          c = (a * 0x01000000) + info[:color]
          self.fill(c)
        end
      end
      
      b = [ImageManager.image('LambdaHaze'),ImageManager.image('LambdaWater'),
        ImageManager.image('LambdaFire'),ImageManager.image('LambdaHaze')
      ]
      b.each_with_index do |image,index|
        subseq(0.67) do |portion|
          image.draw(0,0,ZOrder::Things)
          a = (portion * 0xFF).floor
          c = (a * 0x01000000) + 0xFFFFFF
          self.fill(c)
        end
        next_image = b[index+1]
        if next_image
          subseq(0.33) do |portion|
            next_image.draw(0,0,ZOrder::Things)
            a = ((1-portion) * 0xFF).floor
            c = (a * 0x01000000) + 0xFFFFFF
            self.fill(c)
          end
        end
      end
      
      subseq(0.33) do |portion|
        ImageManager.image('OldTitle').draw(0,0,ZOrder::Things)
        a = ((1-portion) * 0xFF).floor
        c = (a * 0x01000000) + 0xFFFFFF
        self.fill(c)
      end
      
      subseq(0.75) do |portion|
        ImageManager.image('OldTitle').draw(0,0,ZOrder::Things)
      end
      
      subseq(1) do |portion|
        ImageManager.image('OldTitle').draw(0,0,ZOrder::Things)
        a = (portion * 0xFF).floor
        c = (a * 0x01000000) + 0xFF0000
        self.fill(c)
      end
      
      subseq(1) do |portion|
        ImageManager.image('NewTitle').draw(0,0,ZOrder::Things)
        a = ((1-portion) * 0xFF).floor
        c = (a * 0x01000000) + 0xFF0000
        self.fill(c)
      end
      
      subseq(1) do |portion|
        ImageManager.image('NewTitle').draw(0,0,ZOrder::Things)
      end 
      
      font = ImageManager.font(:basic,18)
      x = Sizes::WindowWidth / 2
      y = Sizes::WindowHeight - 20
      subseq(1) do |portion|
        ImageManager.image('NewTitle').draw(0,0,ZOrder::Things)
        font.draw_rel("press any key",x,y,ZOrder::Splash,0.55,0.5,1,1,0xFF990000)
      end
      
    end    
    
    def done
      MainWindow.current_screen = MainWindow.main_menu
    end
  
    def button_down(id)
      self.done
    end
  
  end
end