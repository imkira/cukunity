require 'timeout'

module Cukunity
  module Utils
    def check_timeout(max_time, delay = 0.1)
      start = Time.now
      until yield
        if (Time.now > (start + max_time))
          return true
        end
        sleep delay
      end
      false
    end

    # adapted from Rails
    def to_options(hash)
      raise "Expected a hash but got a #{hash.class}" unless hash.instance_of? Hash
      hash_dup = hash.dup
      hash_dup.keys.each do |key|
        hash_dup[(key.to_sym rescue key) || key] = hash_dup.delete(key)
      end
      hash_dup
    end

    def merge_options(options, defaults = {})
      to_options(defaults).merge(to_options(options))
    end

    def restrict_options(options, *restricted_keys)
      restricted_keys = restricted_keys.map do |key|
        (key.to_sym rescue key) || key
      end
      to_options(options).delete_if do |key, value|
        !restricted_keys.include?(key)
      end
    end

    def wait_connectivity(host, port, max_time)
      begin
        Timeout::timeout(max_time) do
          begin
            s = TCPSocket.new(host, port)
            s.close
            true
          rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            sleep 0.1
            retry
          end
        end
      rescue Timeout::Error
        false
      end
    end
  end
end
