class Public::HomesController < ApplicationController

  def top
    @user = User.all
  end

  def about
  end
  
end
