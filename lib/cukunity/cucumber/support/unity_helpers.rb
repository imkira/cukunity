module Cukunity
  module UnityHelpers
    extend Forwardable
    def_delegator :unity, :screen
    def_delegator :unity, :level
    def_delegator :unity, :load_level
    def_delegator :unity, :scene
    def_delegator :unity, :gameobject
    def_delegator :unity, :gameobjects
    def_delegator :unity, :components
    def_delegator :unity, :hints
    def_delegator :unity, :hint

    def unity
      raise Exception::UnspecifiedPlatform.new if @platform.nil?
      @platform::Unity::Client.instance
    end

    attr_accessor :current_object

    attr_accessor :current_gameobject
    def set_current_gameobject(gameobject)
      self.current_object = gameobject
      self.current_gameobject = gameobject
    end

    attr_accessor :current_component
    def set_current_component(component)
      self.current_object = component 
      self.current_component = component 
    end
  end
end

World(Cukunity::UnityHelpers)
