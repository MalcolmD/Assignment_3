class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = params[:sort]
    @all_ratings = ['G', 'PG', 'PG-13']
    @selected_ratings = ['']
    

  if(@sort.nil?)                            #If not sorted
    if (params[:ratings].nil?)                      #If not rating filtered
      @selected_ratings = @all_ratings
      @movies = Movie.all
    else                                            #If rating filtered
      @selected_ratings = params[:ratings]
      @movies = Movie.where("rating IN (?)", @selected_ratings)
    end
  else                                              #If sorted
     if (params[:ratings].nil?)                     #If not rating filtered
      @selected_ratings = @all_ratings
      @movies = Movie.order("#{@sort} ASC")
    else                                            #If rating filtered
      @selected_ratings = params[:ratings]
      @movies = Movie.order("#{@sort} ASC").where("rating IN (?)", @selected_ratings)
    end
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
