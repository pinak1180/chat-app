class ApiIndexRenderer
  attr_reader :name, :link_ref, :method_type
  
  def initialize(name, link_ref, method_type)
    @name        = name
    @link_ref    = link_ref
    @method_type = method_type
  end
  
  class << self
    def passenger_api_index
      index_arr = []
      index_arr << ApiIndexRenderer.new("Signup", "signup", "POST")
      index_arr << ApiIndexRenderer.new("Login", "login", "POST")
      index_arr << ApiIndexRenderer.new("Change Password", "change_password", "POST")
      index_arr << ApiIndexRenderer.new("Forgot Password", "forgot_password", "POST")
      index_arr << ApiIndexRenderer.new("Logout", "logout", "GET")
      index_arr << ApiIndexRenderer.new("Get Content", "get_content", "GET")
      index_arr
    end
  end
end