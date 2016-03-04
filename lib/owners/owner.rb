module Owners
  # Represents a unique "owner" across any number of OWNERS files.
  #
  # It is a simple wrapper around a {String} with some useful
  # methods for inspecting an owner's type and subscriptions.
  #
  # @api public
  class Owner < SimpleDelegator
    def paths
      subscriptions.keys
    end

    def subscriptions
      @subscriptions ||= Hash.new { |hash, key| hash[key] = [] }
    end

    def type
      case to_s
      when /^!/
        :alert
      when /^[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+$/i
        :email
      when /^@.+\/[^@]+$/
        :group
      when /^@/
        :mention
      when /^#/
        :tag
      else
        :label
      end
    end
  end
end
