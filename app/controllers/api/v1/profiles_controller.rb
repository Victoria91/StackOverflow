class Api::V1::ProfilesController < ApplicationController
  doorkeeper_for :all

  def me
    render nothing: true
  end
end