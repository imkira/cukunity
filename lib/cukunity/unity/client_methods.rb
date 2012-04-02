require 'json'
require 'singleton'

module Cukunity
  module Unity
    module ClientMethods
      include Cukunity::Utils
      include Cukunity::Unity::CommandFacade
      include Cukunity::RequestLineResponseClientMethods
      alias_method :request_connect, :connect

      DEFAULT_HOSTNAME = '127.0.0.1'
      DEFAULT_PORT = 9921

      def command(name, opts = {})
        req = opts.merge({'command' => name})
        res = request(req.to_json) do |line|
          JSON.parse(line)
        end
        raise Exception::UnityCommandError.new(res['error']) if res.nil? or res.has_key?('error')
        res
      end

      private
      def connect(host = DEFAULT_HOSTNAME, port = DEFAULT_PORT)
        request_connect(host, port) do |socket|
          if (line = socket.gets).nil?
            # close and try again
            close
          else
            JSON.parse(line).tap do |ack|
              raise Exception::UnityInvalidAck.new if ack != {}
            end
          end
        end
      end

      def self.included(base)
        # include Singleton methods in the base class
        base.class_eval do
          include Singleton
        end
      end
    end
  end
end
