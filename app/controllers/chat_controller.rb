# app/controllers/chat_controller.rb

class ChatController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end

  def ask
    query = params[:query]
    # answer = GeminiClient.ask(query)
    answer = RagService.ask(query)

    Rails.logger.info "🔥 ANSWER: #{answer.inspect}"

    render json: { reply: answer }
  end
end