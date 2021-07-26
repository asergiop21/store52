class ReportsController < ApplicationController

  def minimum_stock

      @stocks = Article.where("quantity < minimum_stock")     

  end


end
