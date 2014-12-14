class Api::V1::Authentication::UsersController < Api::V1::BaseController
  before_filter :authentication_user_with_authentication_token, :only => [:send_friend_request, :confirm_friend_request]
  def sign_up
    @user = User.new(user_create_params)
    @user.is_online = true
    unless @user.save && (params[:password] == params[:password_confirmation])
      render_json({:result=>{:messages => @user.display_errors, :rstatus=>0, :errorcode => 404}}.to_json)      
    else
      @friends = []
      @new_req = []
      @user.authentication_tokens.destroy_all
      @authentication_token = @user.authentication_tokens.create(:auth_token => AuthenticationToken.generate_unique_token)
    end
  end

  def get_content
    unless params[:content_type].present? && [1,2].include?(params[:content_type].to_i)
      render_json({:result=>{:messages => "content_type parameter missing/Invalid", :rstatus=>0, :errorcode => 404}}.to_json)
    else
      @text = Privacy #User.get_content(params[:content_type])
      @text = @text.html_safe
      render_json({:result=>{:messages =>"ok",:rstatus=>1, :errorcode =>""},:data=>{:content => @text}}.to_json)
    end
  end

  def send_friend_request
    @user = User.find_by(email: params[:email]) if params[:email].present?
    unless params[:email].present? && @user.present?
      render_json({:result=>{:messages => "email empty or invalid", :rstatus=>0, :errorcode => 404}}.to_json)
    else
      if @current_user.friendships.build(:friend_id => @user.id).save
        render_json({:result=>{:messages =>"ok",:rstatus=>1, :errorcode =>""},:data=>{:message => "Friend Request Sent to #{@user.full_name}"}}.to_json)
      else
        render_json({:result=>{:messages => "invalid request", :rstatus=>0, :errorcode => 404}}.to_json)
      end
    end
  end

  def confirm_friend_request
    @user = User.find(params[:friend_id].to_i) if params[:friend_id].present?
    @request = @user.friendships.find_by(friend_id: @current_user.id, confirm_status: false) if params[:friend_id].present?
    unless params[:friend_id].present? && @request.present?
      render_json({:result=>{:messages => "No request found", :rstatus=>0, :errorcode => 404}}.to_json)
    else
      @request.confirm
      render_json({:result=>{:messages =>"ok",:rstatus=>1, :errorcode =>""},:data=>{:message => "Friend Request Sent accepted"}}.to_json)
    end
  end

  private
  def user_create_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :language, :password_confirmation )
  end
end