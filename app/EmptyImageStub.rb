module OperationLambda
  module ImageManager
    class EmptyImageStub
      def initialize(w,h)
        @w, @h = w, h;
      end
      
      def to_blob
        "\0" * @w * @h * 4
      end
      
      def rows
        @h
      end
      
      def columns
        @w
      end
    end
  end
end