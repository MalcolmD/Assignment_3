class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @selected_ratings = ['']
    
    if session[:sort] != params[:sort] and !params[:sort].nil?            #If session was not sorted the same as params and params is sorted
      session[:sort] = params[:sort]                                      #The session will persist the sorted params
    end
    
    if session[:ratings] != params[:ratings] and !params[:ratings].nil?   #If the session rating filter was not the same as params rating filter and params is not filtered
      session[:ratings] = params[:ratings]                                #The session ratings filter will persist the rating filtered params
    end 
    
    if params[:sort].nil? and params[:ratings].nil? and (!session[:sort].nil? or !session[:ratings].nil?) #If params weren't sorted and there was no rating filter and the session had a filter or was sorted
      redirect_to(movies_path(:sort => session[:sort], :ratings => session[:ratings]))                    #Redirect the state back to the session
    end
    @sorted_by = session[:sort]                                           #Contains the last known sorting "state" 
    @selected_ratings = session[:ratings]                                 #Contains the last known ratings filter "state"

    if @sorted_by.nil?                                                    #If last known sorting "state" was none
      @movies = Movie.all                                                 #All movies in db
    else
      @movies = Movie.order(@sorted_by)                                   #Sort by las known sorting "state"
    end

    if @selected_ratings.nil?                                             #If last known session ratings filter was none
      @selected_ratings = @all_ratings                                    #Keep that state
    else
      @selected_ratings = @selected_ratings.keys                          #Grab the current ratings filter "state"
    end

    if @sorted_by.nil?                                                    #If last knonwn sorting "state" was none
       @movies = Movie.find_all_by_rating(@selected_ratings)              #Filter by last known ratings filter "state"
    else
       @movies = Movie.order(@sorted_by).find_all_by_rating(@selected_ratings)  #Filter and order by last known ratings filter "state" and last sorting "state"
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
