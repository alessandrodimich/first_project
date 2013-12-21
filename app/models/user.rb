require 'digest/sha1'
class User < ActiveRecord::Base

  has_many :events

  has_secure_password

  #validates_presence_of :user_name, :first_name, :last_name
  validates_uniqueness_of :user_name, message: "%{value} has already been taken"
  validates_uniqueness_of :email, message: "%{value} is already registered"
  validates_format_of :email, with: /\A[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-zA-Z]{2,}\Z/, on: :create, message: "format is not valid"
  validates_format_of :user_name, with: /\A[a-zA-Z0-9_-]{2,}\Z/, message: "can only contain letters, numbers, spaces, dots, apostrophes and must be at least 2 characters long"
  validates_format_of :first_name, with: /\A[a-zA-Z. ']{2,}\Z/, message: "can only contain letters, spaces, dots, apostrophes and must be at least 2 characters long"
  validates_format_of :last_name, with: /\A[a-zA-Z. ']{2,}\Z/, message: "can only contain letters, spaces, dots, apostrophes and must be at least 2 characters long"

  validates_length_of :password, minimum: 6, message: "must be at least 6 characters long"
  #validates_length_of :user_name, :last_name, minimum: 2, message: "must be at least 2 characters long"


  before_create :generate_star_token

  before_save :format_email_and_name

  #Session token
  def generate_auth_token
    self.auth_token = Digest::SHA1.hexdigest(Time.now.to_f.to_s.sub(".", "") + self.email.to_s)
    self.update_attribute(:auth_token, self.auth_token)
  end

  def send_password_reset
      self.password_reset_token = Digest::SHA1.hexdigest(Time.now.to_f.to_s.sub(".", "") + self.email.to_s)
      self.password_reset_sent_at = Time.now
      self.update_columns(:password_reset_token => self.password_reset_token, :password_reset_sent_at => self.password_reset_sent_at )
      UserMailer.reset_password(self).deliver
  end


private


  #Permanent Token ID
  def generate_star_token
    self.star_token = Digest::SHA1.hexdigest(Time.now.to_f.to_s.sub(".", "") + self.email.to_s + self.user_name.to_s)
  end

  def format_email_and_name
    self.email = self.email.downcase
    self.first_name = self.first_name.capitalize
    self.last_name = self.last_name.capitalize
  end

end
