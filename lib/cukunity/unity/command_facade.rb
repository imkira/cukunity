module Cukunity
  module Unity
    module CommandFacade
      def screen
        Unity::Screen.new(self, command('get_screen'))
      end

      def level
        Unity::Level.new(command('get_level'))
      end

      def load_level(level, max_time = 30)
        level_was_loaded = nil
        options = 
          if level.is_a? String
            level_was_loaded = lambda do
              self.level.name == level
            end
            { 'name' => level }
          else
            level_was_loaded = lambda do
              self.level.number == level.to_i
            end
            { 'number' => level.to_i }
          end
        Unity::Scene.new(self, command('load_level', options))
        raise Exception::UnityCommandError.new if check_timeout(max_time) do
          level_was_loaded.call
        end
      end

      def scene 
        Unity::Scene.new(self, command('get_scene'))
      end

      def gameobjects
        scene.gameobjects
      end

      def gameobject(name)
        gameobjects.find do |gameobject|
          gameobject.value_of('name') == name
        end
      end

      def components(options = {})
        options = merge_options(options, { :recursive => true })
        gameobjects.inject([]) do |components, gameobject|
          components + gameobject.components(options)
        end
      end

      def hints(options = {})
        options = merge_options(options, { :recursive => true })
        gameobjects.inject([]) do |hints, gameobject|
          hints + gameobject.hints(options)
        end
      end

      def hint(options = {})
        hints(options).find do |h|
          yield h
        end
      end
    end
  end
end
