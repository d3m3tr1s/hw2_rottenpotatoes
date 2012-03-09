class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	flag = 0
	if params.has_key?(:sort)
		session[:sort] = params[:sort]
	else
		params[:sort] = session[:sort]
		flag += 1
	end	
	if params.has_key?(:commit) or params.has_key?(:ratings)
		session[:ratings] = nil
		session[:ratings] = params[:ratings] unless params[:ratings] == nil
	elsif
		params[:ratings] = session[:ratings]
		flag += 1 unless session[:ratings] == nil
	end
	
	@sort = params[:sort]
	@ratings = []
	@ratings = params[:ratings].keys unless	params[:ratings] == nil
	
	if flag == 2
		session.clear
		redirect_to params
	end
	
	@all_ratings = Movie.ratings
	if @ratings != []
		@movies = Movie.order("#{@sort}").find_all_by_rating(@ratings)
	else
		@movies = Movie.order("#{@sort}").all
	end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
