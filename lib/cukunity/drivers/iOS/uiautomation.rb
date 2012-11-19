require 'singleton'

module Cukunity
  module IOS
    class UIAutomation
      include Singleton
      include IOS::Utils
      include Cukunity::Utils

      def initialize
        @pipe = nil
        @tmpdir = []
        @pipes = []
      end

      def popen(bundle_id)
        udid = device_udid

        # create a temp directory for instrument logs and js file
        tmpdir = File.expand_path(Dir.mktmpdir(['cukunity_', '_uiautomation']))
        cmd = nil
        begin
          # export javascript to folder too
          slave_js = File.join(tmpdir, 'uiautomation_slave.js')
          slave_rb = File.join(File.dirname(__FILE__), 'uiautomation_slave.rb')
          slave_js_opts = {
            :ruby => File.expand_path(RbConfig.ruby),
            :slave => slave_rb,
            :address => UIAutomationMaster.instance.address,
            :port => UIAutomationMaster.instance.port,
            :bundle_id => bundle_id
          }

          generate_slave_js(slave_js, slave_js_opts)

          # as of Xcode 4.3.2, the Developer folder is now in a different place.
          templates = [
            '/Developer/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate',
            '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate',
            '/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate'
          ]
          template = templates.find do |template|
            File.file?(template)
          end

          # build path to command
          cmd = ['instruments', '-w', udid,
            '-t', template,
            bundle_id,
            '-e', 'UIASCRIPT',
            slave_js,
            '-e', 'UIARESULTSPATH', tmpdir,
            :err => [:child, :out]]
        rescue => err
          FileUtils.remove_entry_secure(tmpdir)
          raise err
        end

        # remove later
        @tmpdir << tmpdir
        # execute UIAutomation instruments
        Dir.chdir tmpdir do
          @pipes << IO.popen(cmd)
        end
      end

      def close
        # close all created pipes
        @pipes.each do |pipe|
          ::Process.kill('KILL', pipe.pid) rescue ::Exception
          pipe.close rescue ::Exception
        end
        @pipes = []
        # remove all created temporary dirs
        @tmpdir.each do |tmpdir|
          FileUtils.remove_entry_secure(tmpdir, true)
        end
        @tmpdir = []
      end

      private
      def generate_slave_js(path, interpolations)
        slave_js = File.join(File.dirname(__FILE__), 'uiautomation_slave.js')
        # read original js file contents
        contents = File.open(slave_js) do |f|
          f.read
        end
        # perform necessary interpolations
        interpolations.each_pair do |key, value|
          if contents.gsub!("{{#{key}}}", value.to_s).nil?
            raise "Could not perform replacement"
          end
        end
        # output
        File.open(path, 'w') do |f|
          f.write(contents)
        end
      end
    end
  end
end
