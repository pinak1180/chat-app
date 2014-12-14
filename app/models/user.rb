class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  ## Virtual Attributes ##         
  attr_accessor :password_conformation  

  ## Validations ##
  validates :first_name, :last_name, :language, :presence => true 

  ## Associations ##
  has_many :friendships, :dependent => :destroy
  has_many :authentication_tokens, :dependent => :destroy

  ## Class Methods ##
  class << self
    def authenticate_user_with_auth(email, password)
      return nil unless email.present? or password.present?
      u = User.find_by_email(email)
      (u.present? && u.valid_password?(password))? u : nil
    end
    
    def invalid_credentials
      "Email or password is not valid"
    end

    def success_message
      {:message=> "ok", :errorcode => "",:rstatus=>1}
    end
    
    def get_content(which)
      which.to_i == 1 ? AppDoc.first.privacy : AppDoc.first.tos
    end    
  end

  ## Instance Methods ##
  def full_name
  	"#{first_name} #{last_name}"
  end

  def need_to_translate?
    self.language != 'en'
  end

  def display_errors
  	self.errors.full_messages.join(',')  	
  end
  
  def email_verified?
    self.email && self.email.split('@').last != "#{self.provider}.com"
  end
end