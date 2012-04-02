module Cukunity
  module PlatformHelpers
    extend Forwardable
    def_delegator :app, :install
    def_delegator :app, :uninstall
    def_delegator :app, :installed
    def_delegator :app, :installed?
    def_delegator :process, :launch
    def_delegator :process, :running
    def_delegator :process, :foreground
    def_delegator :process, :foreground?
    def_delegator :process, :running?
    def_delegator :process, :pids
    def_delegator :process, :relaunch
    def_delegator :input, :touch_screen
    def_delegator :keyboard, :keyboard

    def current_app
      raise Exception::InvalidApp.new if @current_app.nil?
      @current_app
    end

    def current_app=(path)
      case File.extname(path).downcase
      when '.app'
        set_current_app_ios(path)
      when '.apk'
        set_current_app_android(path)
      else
        # @ios is defined as a tag?
        tags = @@__tags__
        if tags.include?('@ios') or tags.include?('@~android')
          path = set_current_app_ios("#{path}.app")
        # @android is defined as a tag?
        elsif tags.include?('@android') or tags.include?('@~ios')
          path = set_current_app_android("#{path}.apk")
        else
          raise Exception::InvalidApp.new(path)
        end
      end
      @current_app = path
    end

    def set_current_app(path)
      self.current_app = path
    end

    def platform_defined?
      not @platform.nil?
    end

    def app
      raise Exception::UnspecifiedPlatform.new if @platform.nil?
      @platform::App
    end

    def process
      raise Exception::UnspecifiedPlatform.new if @platform.nil?
      @platform::Process
    end

    def touch
      raise Exception::UnspecifiedPlatform.new if @platform.nil?
      @platform::TouchInput
    end

    def keyboard 
      raise Exception::UnspecifiedPlatform.new if @platform.nil?
      @platform::KeyboardInput
    end

    def self.__tags__=(tags)
      @@__tags__ = tags
    end

    private
    def set_current_app_ios(path)
      raise Exception::InvalidApp.new(path) unless File.directory?(path)
      @platform = Cukunity::IOS
      path
    end

    def set_current_app_android(path)
      raise Exception::InvalidApp.new(path) unless File.file?(path)
      @platform = Cukunity::Android
      path
    end
  end
end

World(Cukunity::PlatformHelpers)

AfterConfiguration do |config|
  # FIXME: we should not use an undocumented/deprecated member.
  # gherkin's tag_expressions method does not allow us to inspect the list
  # of defined tags or to eval against a subset of tags.
  # If the user defines new tags we would't know about as a consequence
  # tag_expressions.eval(_the_tags_we_know_) will probably fail.
  # Therefore, we access @options[:tag_expressions] directly.
  options = config.instance_variable_get('@options') 
  tags = options[:tag_expressions].inject([]) do |tags, tag|
    tags += tag.split(/\s*,\s*/)
  end
  Cukunity::PlatformHelpers.__tags__ = tags
end
