require 'FileUtils'

require 'Platform'
require 'Levelset/Bigboard'
require 'Levelset/Smallboard'


module OperationLambda
  class Levelset
    
    LevelsetLoaders = {
      'bigboard'   => Levelset::Bigboard,
      'smallboard' => Levelset::Smallboard
    }
    
    def self.create_levelset(dir,title,author)
      target_dir = File.join(Platform::UserLevelsetsDir,dir)
      if File.exists?(target_dir)
        raise "A levelset already exists with that name."
      else
        Dir.mkdir(target_dir)
        metadata = {
          'levelset' => dir,
          'title'    => title,
          'authors'  => [author],
          'levels'   => 0,
          'datatype' => 'smallboard',
          'details'  => {'files' => []}
        }
        File.open(File.join(target_dir,'metadata.yaml'),'w') do |meta_file|
          YAML.dump(metadata,meta_file)
        end
        return self.new({:cat=>:user,:dir=>dir})
      end
    end
    
    def self.clone_levelset(old,dir,title,author)
      target_dir = File.join(Platform::UserLevelsetsDir,dir)
      old_dir = old.directory
      if File.exists?(target_dir)
        raise "A levelset already exists with that name."
      else
        Dir.mkdir(target_dir)
        FileUtils.cp_r("#{old_dir}/.", target_dir)
        meta_path = File.join(target_dir,"metadata.yaml")
        metadata = YAML.load_file(meta_path)
        metadata['levelset'] = dir
        metadata['title'] = title
        metadata['authors'] = Array(author)
        File.open(meta_path,'w') do |meta_file|
          YAML.dump(metadata,meta_file)
        end
        return self.new({:cat=>:user,:dir=>dir})
      end
    end
    
    def self.app_levelsets
      pdir = Dir.new(Platform::ApplicationLevelsetsDir)
      (pdir.entries - ['.','..']).map {|item| File.join(pdir.path,item)}.select {|path| File.directory?(path)}.map {|dir| Levelset.new({:dir => File.basename(dir), :cat => :app})}
    end
    
    def self.user_levelsets
      pdir = Dir.new(Platform::UserLevelsetsDir)
      (pdir.entries - ['.','..']).map {|item| File.join(pdir.path,item)}.select {|path| File.directory?(path)}.map {|dir| Levelset.new({:dir => File.basename(dir), :cat => :user})}
    end
    
    def self.all
      self.app_levelsets + self.user_levelsets
    end
    
    attr_reader :key, :directory
    
    def initialize(key)
      @key = key
      @category = @key[:cat]
      @directory = if @category == :user
        File.join(Platform::UserLevelsetsDir,@key[:dir])
      else
        File.join(Platform::ApplicationLevelsetsDir,@key[:dir])
      end
      @metadata = YAML.load_file(File.join(@directory,"metadata.yaml"))
      @datatype = @metadata['datatype']
      @details = @metadata['details']
      unless loader_module = LevelsetLoaders[@datatype]
        raise "Unable to load levelset '#{@directory}': no loader for levelset type '#{@datatype}'."
      end
      metaclass = (class << self; self; end)
      metaclass.class_eval {include loader_module}
    end
    
    def key_for_hashes
      [@key[:cat],@key[:dir]]
    end
    
    
    def metadata
      @metadata.dup
    end
    
    def commit
      @metadata['details'] = @details
      File.open(File.join(@directory,"metadata.yaml"),"w") do |f|
        YAML.dump(@metadata,f)
      end
    end 
    
    def preview_for_level(level)
      return ImageManager.image('Stars') unless Settings[:show_previews]
      floor_image = ImageManager.tile('Floor').static
      level_image = ImageManager.empty(Sizes::MapWidth,Sizes::MapHeight)
      places = self.load_level(level)[:places]
      level_image.paint do |pic|
        pic.splice(ImageManager.image('Stars'),0,0)
        places.each_index do |x|
          places[x].each_index do |y|
            obj = places[x][y]
            xpos = x * Sizes::TileWidth
            ypos = y * Sizes::TileHeight
            unless (obj == 'Space')
              pic.splice(floor_image,xpos,ypos)
            end
            unless (obj.in? ['Empty','Space'])
              img = ImageManager.tile(obj).static
              pic.splice(img,xpos,ypos,:mask => :_alpha)            
            end
            # TODO: Add laser beams to level previews.
          end #places[x].each_index
        end #places.each_index
      end #level_image.paint
      return level_image
    end #def preview_for_level
    
  end
end