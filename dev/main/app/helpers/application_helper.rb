# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def show_info
    unless (params[:window_id].nil? || session[params[:window_id]].nil?)
      return "<p class=\"#{session[params[:window_id]][:message][:msg_type]}\">#{session[params[:window_id]][:message][:msg_text]}</p>"
    end
    unless (@message.nil?)
      return "<p class=\"#{@message[:msg_type]}\">#{@message[:msg_text]}</p>"
    end
  end
  
end
