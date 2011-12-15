# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
require 'digest'
class User < ActiveRecord::Base
	attr_accessor :password
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	attr_accessible :name,:email,:password,:password_confirmation
	validates :name,:presence =>true,:length=>{:maximum =>50}
	validates :email,:presence =>true,:format=>{:with=>email_regex},
                  :uniqueness => {:case_sensitive => false}
	validates :password,:confirmation =>true,
		  :length => {:within=>6..40}
  	before_save :encrypt_password

        def has_password?(submitted_password)
 		encrypted_password == encrypt(submitted_password)
        end
        
 	def self.authenticate(email,matchpass)
            user = find_by_email(email)
            return nil if user.nil?
            return user if user.has_password?(matchpass)
	end

        def self.authenticate_with_salt(id, cookie_salt)
  	     user = find_by_id(id)
   	    (user && user.salt == cookie_salt) ? user : nil
        end


   	private
             def encrypt_password
                 self.salt = make_salt unless has_password?(password)
                 self.encrypted_password = encrypt(password)
 	     end
             
             def  encrypt(string)
                  secure_hash("#{salt}--#{string}")
             end
             
             def make_salt
                 secure_hash("#{Time.now.utc}--#{password}")
             end 
             
             def secure_hash(string)
                  Digest::SHA2.hexdigest(string)
             end                   
	
end
