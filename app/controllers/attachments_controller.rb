# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @file&.purge
end
