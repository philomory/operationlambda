require 'Constants'

module OperationLambda
  class Screen
    attr_reader :parent
    attr_accessor :text_input
    
    def update; end
    
    def draw; end
    
    def draw_line(*args)
      MainWindow.draw_line(*args)
    end

    def draw_triangle(*args)
      MainWindow.draw_triangle(*args)
    end
    
    def draw_quad(*args)
      MainWindow.draw_quad(*args)
    end
    
    def fill(c,z=ZOrder::Splash)
      draw_quad(0,0,c,Sizes::WindowWidth,0,c,0,Sizes::WindowHeight,c,Sizes::WindowWidth,Sizes::WindowHeight,c,z)
    end
    
    def button_down(id); end
    
    def button_up(id); end
    
    def button_down?(id)
      MainWindow.button_down?(id)
    end
    
    def char_to_button_id(char)
      MainWindow.char_to_button_id(char)
    end
    
    def button_id_to_char(id)
      MainWindow.button_id_to_char(id)
    end
    
    def wordwrap(message,width,font)
      word_array = message.split(' ')
      lines = [word_array.shift]
      word_array.each do |word|
        if font.text_width("#{lines[-1]} #{word}") < width
          lines[-1] << ' ' << word
        else
          lines.push(word)
        end
      end
      return lines
    end
    
    def should_play_music?
      false
    end
    
  end
end