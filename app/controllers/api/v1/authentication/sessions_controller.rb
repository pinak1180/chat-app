class Api::V1::Authentication::SessionsController < Api::V1::BaseController

  #before_filter :authentication_user_with_authentication_token, :only => [:destroy]
  def create
    @user = User.authenticate_user_with_auth(params[:email], params[:password])
    if @user.present?
      @user.update_attributes(is_online: true)
      @user.authentication_tokens.destroy_all
      @authentication_token = @user.authentication_tokens.create(:auth_token => AuthenticationToken.generate_unique_token)
      @friends_data = @user.friendships
      @friends = Friendship.where("(user_id = ? OR friend_id = ?) AND confirm_status = ?", @user.id, @user.id, true)
      @new_req = Friendship.where(friend_id: @user.id, confirm_status: false)
      render :file => "api/v1/authentication/users/sign_up"
    else      
      render_json({:result=>{:messages => User.invalid_credentials,:rstatus=>0, :errorcode => 404}}.to_json)
    end
  end
  
  def destroy
    @token = AuthenticationToken.find_by(auth_token: params[:authentication_token])
    if @token.present?
      @user.update_attributes(is_online: false)
      @token.destroy
       render_json({:result=>{:messages =>"ok",:rstatus=>1, :errorcode =>""},:data=>{:messages =>"Logout Sucessfully"}}.to_json)    
    else
      render_json({:errors => "No user found with authentication_token = #{params[:authentication_token]}"}.to_json)
    end
  end  
end