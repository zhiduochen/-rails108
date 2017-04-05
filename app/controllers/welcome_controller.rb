class WelcomeController < ApplicationController
  def index
    flash[:notice] = "欢迎，你可以参与电影评论，感谢你写下你的观影心得，独乐乐，不如众乐乐！"
  end
end
