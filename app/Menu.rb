require 'gosu'
require 'Screen'
require 'YAML'

require 'TextField'


#TODO: Rework menu system, making it more an API rather than a subclass for each menu. Low priority.
module OperationLambda
  module Menu
    class BasicMenu < Screen
      attr_reader :parent, :font
      
      def initialize
        @selection_index = 0
        @y_offset = 0
        @font = ImageManager.font(:menu,40)
        @background = ImageManager.image('Background')
        @items_array = []
      end
      
      def button_down(id)
        case id
        when *[Gosu::KbSpace,Gosu::KbEnter,Gosu::KbReturn]
          @items_array[@selection_index].selected
        when Gosu::KbDown
          @selection_index = (@selection_index + 1) % @items_array.length
        when Gosu::KbUp
          @selection_index = (@selection_index - 1) % @items_array.length
        when Gosu::KbRight
          @items_array[@selection_index].incr
        when Gosu::KbLeft
          @items_array[@selection_index].decr
        when Gosu::KbTab # for use in text fields, mostly. They eat the up and down keys.
          if button_down?(Gosu::KbLeftShift) or button_down?(Gosu::KbRightShift)
            @selection_index = (@selection_index - 1) % @items_array.length
          else
            @selection_index = (@selection_index + 1) % @items_array.length
          end
        when Gosu::KbEscape
          self.back
        end
      end #def button_down
  
      def draw
        if @background.respond_to? :draw
          @background.draw(0,0,ZOrder::Stars) #,1,1,0x77ffffff)
        end
        @items_array.each_with_index do |item,index|
          ypos = 50 + ((@font.height+10)*index) + @y_offset
          if index == @selection_index
            color = 0xffff0000
          else
            color = 0x77ff0000
          end
          item.draw(@font,10,ypos,color)
        end
      end #def draw
      
      # This method should be overridden by menus in which going 'back' does not
      # mean returning to the parent screen.
      def back
        if @parent
          MainWindow.current_screen = @parent
        end
      end
      
      def add(item)
        @items_array << item
      end
      
    end #class BasicMenu
      
    class BaseMenuItem
          
      def title
        if @title.is_a? Proc
          @title.call
        else
          @title
        end
      end
      
      def selected
        if @selected_action
          @selected_action.call
        end
      end
      
      def incr
        if @incr_action
          @incr_action.call
        end
      end
      
      def decr
        if @decr_action
          @decr_action.call
        end
      end
      
      def draw(font,x,y,color)
        font.draw_rel(self.title,Sizes::WindowWidth/2,y,ZOrder::Splash,0.5,0,1,1,color)
      end #draw
    end
    
    class MenuItem < BaseMenuItem
      
      def initialize(title,&action)
        @title = title
        @selected_action = action
      end #def initialize
    
    end
    
    class BackItem < BaseMenuItem
      def initialize(menu,title="Back")
        @menu, @title = menu, title
      end
      
      def selected
        @menu.back
      end
    end
    
    
    class NumberSettingMenuItem < BaseMenuItem
      def initialize(title,key,range)
        @title = title
        @key = key
        @range = range
        
        @incr_action = lambda do
          if self.range.include?(Settings[@key] + 1)
            Settings[@key] += 1
          end
        end
        @decr_action = lambda do
          if self.range.include?(Settings[@key] - 1)
            Settings[@key] -= 1
          end
        end
      end #def initialize
      
      def range
        if @range.is_a? Proc
          @range.call
        else
          @range
        end
      end
      
    end #class NumberSettingMenuItem
    
    # Dumb hack since only OS X seems to do char substitution.
    # At least, Windows doesn't. Not sure about Linux.
    ON, OFF = if RUBY_PLATFORM =~ /darwin/
                ["\342\234\223", "\342\234\227"] # Checkmark, X-mark
              else
                ["On","Off"]
              end
    
    class ToggleSettingMenuItem < BaseMenuItem
      def initialize(str,key)
        # @title = lambda{Settings[key] ? "#{str}: \342\230\221" : "#{str}: \342\230\222"}
        @title = lambda{Settings[key] ? "#{str}: \342\234\223" : "#{str}: \342\234\227"}
        
        @selected_action = @incr_action = @decr_action = lambda {Settings[key] = !Settings[key]}
      end #def intialize
    end #class ToggleSettingMenuItem

    class TextFieldMenuItem < BaseMenuItem
      attr_reader :field, :label
      def initialize(label,field_font,text_when_empty="")
        @label = label
        @field = TextField.new(MainWindow.instance,field_font,text_when_empty)
      end
      
      def draw(font,x,y,color)
        label_end = font.text_width(@label)
        field_x = x + label_end + 10
        font.draw(@label,x,y,ZOrder::Splash,1,1,color)
        @field.draw(field_x,y)
      end
      
      def text
        @field.text
      end
      
      def text=(text)
        @field.text=(text)
      end
      
    end
    
    class TextFieldMenu < BasicMenu
      def button_down(id)
        s_i = @selection_index
        super(id)
        if s_i != @selection_index
          if @items_array[@selection_index].respond_to?(:field)
            self.text_input = @items_array[@selection_index].field
          else
            self.text_input = nil
          end
        end
      end
      def select_first
        @selection_index = 0
        if @items_array[0].respond_to?(:field)
          self.text_input = @items_array[0].field
        end
      end
    end
    
    
    class AdvancedMenuItem < BaseMenuItem
      def initialize(&block)
        instance_eval(&block)
      end #def initialize
    end #class AdvancedMenuItem
    
  end #module Menu
end #module OperationLambda