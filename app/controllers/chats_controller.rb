class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: %i[show]
  before_action :set_chats_collection, only: %i[index show]
  respond_to :html

  def index; end

  def show
    respond_with(@chat)
  end

  def create
    @chat = Chat.includes(:messages).where(user: current_user, messages: { id: nil }).first_or_create
    respond_with(@chat)
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def set_chats_collection
    @chats = Chat.all
  end
end
