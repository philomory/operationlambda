#Based on code from Gosu's examples, examples/TextInput.rb

module OperationLambda
  class TextField < Gosu::TextInput
    # Some constants that define our appearance.
    INACTIVE_COLOR    = 0xcc666666
    ACTIVE_COLOR      = 0xccff6666
    SELECTION_COLOR   = 0xcc0000ff
    CARET_COLOR       = 0xffffffff
    PLACEHOLDER_COLOR = 0xffcccccc
    TEXT_COLOR        = 0xffffffff
    PADDING = 5

    def initialize(window,font,text_when_empty)
      # TextInput's constructor doesn't expect any arguments.
      super()

      @window, @font, @text_when_empty = window, font, text_when_empty

    end

    def draw(x,y)
      # Depending on whether this is the currently selected input or not, change the
      # background's color.
      if @window.text_input == self then
        background_color = ACTIVE_COLOR
      else
        background_color = INACTIVE_COLOR
      end
      @window.draw_quad(x - PADDING,         y - PADDING,          background_color,
      x + width + PADDING, y - PADDING,          background_color,
      x - PADDING,         y + height + PADDING, background_color,
      x + width + PADDING, y + height + PADDING, background_color, 0)

      # Calculate the position of the caret and the selection start.
      pos_x = x + @font.text_width(self.text[0...self.caret_pos])
      sel_x = x + @font.text_width(self.text[0...self.selection_start])

      # Draw the selection background, if any; if not, sel_x and pos_x will be
      # the same value, making this quad empty.
      @window.draw_quad(sel_x, y,          SELECTION_COLOR,
      pos_x, y,          SELECTION_COLOR,
      sel_x, y + height, SELECTION_COLOR,
      pos_x, y + height, SELECTION_COLOR, 0)

      # Draw the caret; again, only if this is the currently selected field.
      if @window.text_input == self then
        @window.draw_line(pos_x, y,          CARET_COLOR,
        pos_x, y + height, CARET_COLOR, 0)
      end

      # Finally, draw the text itself!
      draw_color = self.text == "" ? PLACEHOLDER_COLOR : TEXT_COLOR
      @font.draw(self.draw_text, x, y,ZOrder::Splash,1,1,draw_color)
    end

    def draw_text
      self.text == "" ? @text_when_empty : self.text
    end

    # This text field grows with the text that's being entered.
    # (Without clipping, one has to be a bit creative about this ;) )
    def width
      @font.text_width(self.draw_text)
    end

    def height
      @font.height
    end
  end
end