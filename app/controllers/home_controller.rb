class HomeController < ApplicationController
  def index; end
  layout 'home', only: [:index]
end
