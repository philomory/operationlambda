require 'helper'
require 'Settings'
require 'ImageManager'

OperationLambda.build_hash_of_gosu_button_id_names()

module OperationLambda
  module Menu
    class KeyConfigMenu < BasicMenu
      attr_accessor :waiting_for_key
      def initialize(parent)
        super()
        @parent = parent
        
        @waiting_for_key = false
        @items_array = []
        @font = ImageManager.font(:basic,20)
        menu = self
        kcontext = self.context
        k = self.keys
        k.each do |ary|
          sym, str = *ary
          val = Settings[:key_config][kcontext].key(sym)
          vname = GosuButtonIdNames[val]
          item = AdvancedMenuItem.new {
            class << self; attr_reader :key; end
            @key = sym
            @title = lambda{"#{str}: #{GosuButtonIdNames[Settings[:key_config][kcontext].key(sym)]}"}
            @selected_action = lambda {menu.waiting_for_key = true}
          }
          @items_array.push(item)
        end
        @items_array.push(BackItem.new(self))
      end
      
      def keys
        raise "Subclass must override keys method!"
      end
      
      def context
        raise "Subclass must override context method!"
      end
      
      def button_down(id)
        if id == Gosu::KbEscape
          self.back
        elsif @waiting_for_key
          key = @items_array[@selection_index].key
          Settings[:key_config][self.context].delete_if {|k,v| v == key}
          Settings[:key_config][self.context][id] = key
          @waiting_for_key = false
        else
          super
        end
      end
    end
  end
end