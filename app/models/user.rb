class User < ActiveRecord::Base
has_secure_password
has_many :workouts
# validates_presence_of :username, :email, :password
validates :username, presence: true
validates :password, presence: true
# validates_uniqueness_of :password

def slug
      self.username.downcase.gsub(" ", "-")
    end

    def self.find_by_slug(slug)
      self.all.detect do|user|
        user.slug == slug
      end
    end
end
