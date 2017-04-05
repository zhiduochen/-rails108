class MoviesController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy, :join, :quit]
  before_action :find_movie_and_check_permission, only: [:edit, :update, :destroy]
  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
    @reviews = @movie.reviews.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def edit
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user
    if @movie.save
      current_user.join!(@movie)
       redirect_to movies_path
    else
       render :new
    end
  end

  def update
    if @movie.update(movie_params)
      redirect_to movies_path, notice: 'Update Success'
    else
      render :edit
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_path, alert: 'Movie delete'
  end

  def join
    @movie = Movie.find(params[:id])

     if !current_user.is_member_of?(@movie)
       current_user.join!(@movie)
       flash[:notice] = "收藏电影！"
     else
       flash[:warning] = "你已经收藏了此电影了！"
     end

     redirect_to movie_path(@movie)
   end

   def quit
     @movie = Movie.find(params[:id])

     if current_user.is_member_of?(@movie)
       current_user.quit!(@movie)
       flash[:alert] = "已取消收藏！"
     else
       flash[:warning] = "你还未收藏此电影，怎么取消！ XD"
     end

     redirect_to movie_path(@movie)
   end

  private

  def find_movie_and_check_permission
    @movie = Movie.find(params[:id])

    if current_user != @movie.user
      redirect_to root_path, alert: "You have no permission."
    end
  end

  def movie_params
    params.require(:movie).permit(:title, :description)
  end

end
