class Api::V1::Authentication::PasswordsController < Api::V1::BaseController
 before_filter :authentication_user_with_authentication_token, :only => [:change_password]
  
  def create
    if params[:email].present?      
      @user = User.where("email = lower(?)",params[:email]).first
      if @user.present?
         @user.send_reset_password_instructions
         render_json({:result=>{:messages =>"ok",:rstatus=>1, :errorcode =>""},:data=>{:messages =>"You will receive an email with instructions about how to reset your password in a few minutes."}}.to_json)    
      else
        render_json({:result=>{:messages => "No user found with email #{params[:email]}",:rstatus=>0, :errorcode => 404}}.to_json)
      end
    else
      render_json({:result=>{:messages => "Email Address is required",:rstatus=>0, :errorcode => 404}}.to_json)
    end
  end
  
  
  def change_password
    if params[:user][:current_password].present? && params[:user][:password].present?
      @user = @current_user.update_with_password(change_password_params)
      if @user
        render_json({:result=>{:messages =>"ok",:rstatus=>1, :errorcode =>""},:data=>{:messages =>"Your Password has been reset"}}.to_json)
      else
        render_json({:result=>{:messages =>@current_user.display_errors,:rstatus=>0, :errorcode => 404}}.to_json)
      end
    else
      render_json({:result=>{:messages =>"Current Password and Password required",:rstatus=>0, :errorcode => 404}}.to_json)
    end
  end

  private
  def change_password_params
   params.require(:user).permit(:current_password,:password)
 end
end