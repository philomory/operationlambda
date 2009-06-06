require 'Platform'

module OperationLambda
  module HighScore
    module Manager
      HighScoreFile = File.join(Platform::UserDir,'highscore.yaml')
      DefaultHighScores = [
        {:name => 'Lambda', :level => 1, :score => 600},
        {:name => 'Lambda', :level => 1, :score => 500},
        {:name => 'Lambda', :level => 1, :score => 400},
        {:name => 'Lambda', :level => 1, :score => 300},
        {:name => 'Lambda', :level => 1, :score => 200},
        {:name => 'Lambda', :level => 1, :score => 100}
      ]
      
      
      module_function
      
      def init_high_scores
        all_scores = self.scores
        levelsets = Levelset.all
        must_write = false
        levelsets.each do |levelset|
          unless all_scores.has_key?(levelset.key_for_hashes)
            set_scores = levelset.metadata[:default_high_scores] || DefaultHighScores.dup
            all_scores[levelset.key_for_hashes] = set_scores
            must_write = true
          end
        end
        self.write_scores(all_scores) if must_write
      end
      
      def scores
        if File.exists?(HighScoreFile)
          YAML.load_file(HighScoreFile)
        else
          key = {:cat => :app, :dir => 'OperationLambda'}
          scores = {key => DefaultHighScores}
          self.write_scores(scores)
          return scores
        end
      end
      
      def levelset_scores(levelset)
        set_scores = self.scores[levelset.key_for_hashes]
        set_scores ||= write_default_levelset_scores(levelset)
        return set_scores          
      end
      
      def write_scores(all_scores)
        File.open(HighScoreFile,'w') do |hsf|
          YAML.dump(all_scores,hsf)
        end
      end
      
      def write_default_levelset_scores(levelset)
        set_scores = levelset.metadata[:default_high_scores] || DefaultHighScores
        self.write_levelset_scores(levelset,set_scores)
        return set_scores
      end
      
      def clear_all_scores
        if File.exists?(HighScoreFile)
          File.delete(HighScoreFile)
        end
        self.init_high_scores
      end
      
      def top_scores
        self.scores.values.flatten.sort {|a,b| b[:score] <=> a[:score]}.first(6)
      end
      
      def write_levelset_scores(levelset,set_scores)
        all_scores = self.scores
        all_scores[levelset.key_for_hashes] = set_scores
        self.write_scores(all_scores)
      end
      
      def high_score?(levelset,score)
        score > self.levelset_scores(levelset)[5][:score]
      end
      
      def new_score_entry(levelset,score)
        set_scores = self.levelset_scores(levelset)
        new_entry = {:name => :INSERT, :score => score}
        new_set_scores = set_scores.push(new_entry).sort {|a,b| b[:score] <=> a[:score]}.first(6)
        return new_set_scores
      end
      
      def add_entry(levelset,name,level,score)
        set_scores = self.levelset_scores(levelset)
        new_entry = {:name => name, :level => level, :score => score}
        new_set_scores = set_scores.push(new_entry).sort {|a,b| b[:score] <=> a[:score]}.first(6)
        self.write_levelset_scores(levelset,new_set_scores)
      end
    end
  end
end
