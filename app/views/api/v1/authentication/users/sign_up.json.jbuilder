json.partial! 'api/v1/authentication/users/user_details', user: @user
json.friends do
	json.array! @friends.each do |friend| 
		json.partial! 'api/v1/authentication/users/user_details', user: @user.id == friend.user_id ? friend.friend : friend.user
		json.channel_id friend.channel_id
		json.unread_count friend.unread_count
	end
end
json.new_request do
	json.array! @new_req.each do |friend| 
		json.partial! 'api/v1/authentication/users/user_details', user: friend.user
	end
end
json.extract! @authentication_token, :auth_token