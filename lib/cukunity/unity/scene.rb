module Cukunity
  module Unity
    class Scene < Unity::JSONContainer
      attr_reader :client

      def initialize(client, *args)
        @client = client
        super(*args)
      end

      def gameobjects
        @gameobjects ||= (value_of('gameObjects') || []).map do |json|
          Unity::GameObject.new(json, self)
        end
      end
    end
  end
end
