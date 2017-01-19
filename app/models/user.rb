class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
   has_many :articles
   has_many :comments
   include PermissonsConcern

   def avatar
   	email_address = self.email.downcase
   	hash = Digest::MD5.hexdigest(email_address)
   	image_scr = "http://www.gravatar.com/avatar/#{hash}"
   end
end
