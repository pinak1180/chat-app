class AuthenticationToken < ActiveRecord::Base
  ## Associations ##
  belongs_to :user
  
  ## Validations ##
  validates :auth_token, :user_id, :presence => true

  ## Scope ##
  scope :current_authentication_token_for_user, lambda{|user_id,token| joins(:user).where("users.id =? and auth_token = ?",user_id,token).readonly(false)}

  ## Class Methods ##
  class << self
    def generate_unique_token
      token = SecureRandom.hex(20)
      while AuthenticationToken.find_by_auth_token(token)
        token = SecureRandom.hex(20)
      end
      token
    end

    def find_user_from_authentication_token(token)
      u = where(auth_token:token).includes(:user)
      (u.present? && u.first.user.present?)? u.first.user : nil
    end
  end	
end
