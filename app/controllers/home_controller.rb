class HomeController < ApplicationController
  layout 'home', only: [:index]
  def index; end
  layout 'home', only: [:index]
end
