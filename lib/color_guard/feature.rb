require 'zlib'

module ColorGuard
  class Feature
    attr_accessor :users, :percentage
    attr_reader :name

    def initialize(name, string = nil)
      @name = name

      if string
        raw_percentage, raw_users = string.split("|")
        @percentage = raw_percentage.to_i
        @users = (raw_users || "").split(",").map(&:to_s)
      else
        clear
      end
    end

    def serialize
      "#{@percentage}|#{@users.join(",")}"
    end

    def add_user(user)
      id = user_id(user)
      @users << id unless @users.include?(id)
    end

    def remove_user(user)
      @users.delete(user_id(user))
    end

    def clear
      @users = []
      @percentage = 0
    end

    def active?(user)
      if user.nil?
        @percentage == 100
      else
        id = user_id(user)
        user_in_percentage?(id) || user_in_active_users?(id)
      end
    end

    private

    def user_id(user)
      if user.is_a?(Fixnum) || user.is_a?(String)
        user.to_s
      else
        user.id.to_s
      end
    end

    def user_in_percentage?(user)
      Zlib.crc32(user_id_for_percentage(user)) % 100 < @percentage
    end

    def user_id_for_percentage(user)
      user_id(user).to_s + @name.to_s
    end

    def user_in_active_users?(user)
      @users.include?(user_id(user))
    end
  end
end
