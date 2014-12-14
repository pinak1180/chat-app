class Friendship < ActiveRecord::Base

	## Associations ##
	belongs_to :user
	belongs_to :friend, :class_name => "User"

	## Validations ##
	validates :user_id, :friend_id, :presence => true
	validates_uniqueness_of :friend_id, scope: [:user_id]

	## Scope ##
	scope :confirmed_user_friends, -> (user_id){ where("(user_id = ? OR friend_id = ?) AND confirm_status = ?", user_id, user_id, true) }
	scope :new_requests, -> (user_id){where(friend_id: user_id, confirm_status: false)}	
	scope :online_channel_ids, -> (online_user_ids){ where("(user_id IN (?) OR friend_id IN (?)) AND confirm_status = ?", online_user_ids, online_user_ids, true).pluck(:channel_id) }
	scope :find_channel, -> (sid,rid){where("channel_id IN (?)", ["ChatApp_#{sid}_#{rid}","ChatApp_#{rid}_#{sid}"])}

	## Methods ##
	def confirm
		self.confirm_status = true
		self.channel_id = "ChatApp_#{self.user_id}_#{self.friend_id}"
		self.save
		MyPubnub.subscribe(
		    :channel  => self.channel_id,
		    :callback => My_callback
		)
	end

	def increment_unread
		self.update_attributes(unread_count: (self.unread_count + 1))
	end

	def self.reset_unread(user)
		channels = confirmed_user_friends(user.id)
		channels.update_all(unread_count: 0)
	end

	def self.message_callback(message)
		puts "------in callback----#{message}"
		if (message[:isTranslated] == false || message[:isTranslated] == 'false')
			sender = User.find(message[:sid].to_i)
			receiver = User.find(message[:rid].to_i)
			channel = find_channel(sender.id,receiver.id).first
			channel.increment_unread if !sender.is_online || !receiver.is_online
			if receiver.need_to_translate?
				puts "-----message====> #{message}"
				text = translate_message(message[:message], receiver.language)
				puts "translated text = > #{text}"
				translated_message = {:sid => sender.id, :rid => receiver.id, :message => text, :mid => message[:mid], :isTranslated => true}
				send_message(translated_message, channel)
			end
			puts "-------#{message}"
		end
	end

	def self.translate_message(text,language)
		puts "-----in Translating-----"
		client_id = Rails.application.secrets.client_id
		client_secret = Rails.application.secrets.client_secret
		translator = BingTranslator.new(client_id, client_secret)
		text = translator.translate text, :to => language
	end

	def self.send_message(translated_message, channel)
		logger.warn("-----in Publish-----")
		MyPubnub.publish(
    		:channel  => channel.channel_id,
    		:message  => translated_message,
    		:callback => My_callback
		)
		logger.warn("======published=====")
	end
end