class ApplicationController < Sinatra::Base

   # Add this line to set the Content-Type header for all responses
   set :default_content_type, 'application/json'

  # Our React component to display all the games may look like this.......

  # function GameList() {
  #   const [games, setGames] = useState([]);
  
  #   useEffect(() => {
  #     fetch("http://localhost:9292/games")
  #       .then((r) => r.json())
  #       .then((games) => setGames(games));
  #   }, []);
  
  #   return (
  #     <section>
  #       {games.map((game) => (
  #         <GameItem key={game.id} game={game} />
  #       ))}
  #     </section>
  #   );
  # }
  

  get '/games' do
    #get all the games from the database
    games = Game.all
    # return a JSON response with an array of all the game data
    games.to_json
  end

  # sort in order of title

  get '/gamestitle' do
    games = Game.all.order(:title)
    games.to_json
  end

  # return the first 10 games

  get '/10games' do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end


  #............................................. GETTING ONE GAMES USING PARAMS .................

  # We essentially want to set up a component that will display the detatils about one specifici game, and the associatied reviews, tje component may look lik...


  # -----------------------------------

  # function GameDetail({ gameId }) {
  #   const [game, setGame] = useState(null);
  
  #   useEffect(() => {
  #     fetch(`http://localhost:9292/games/${gameId}`)
  #       .then((r) => r.json())
  #       .then((game) => setGame(game));
  #   }, [gameId]);
  
  #   if (!game) return <h2>Loading game data...</h2>;
  
  #   return (
  #     <div>
  #       <h2>{game.title}</h2>
  #       <p>Genre: {game.genre}</p>
  #       <h4>Reviews</h4>
  #       {game.reviews.map((review) => (
  #         <div>
  #           <h5>{review.user.name}</h5>
  #           <p>Score: {review.score}</p>
  #           <p>Comment: {review.comment}</p>
  #         </div>
  #       ))}
  #     </div>
  #   );
  # }

  # -------------------

  # Using the :id syntax to create a dynamic route

  get '/games/:id' do
    # look up the game in the db using its ID
    game = Game.find(params[:id])
    #  send a JSON-formatted response of the game data
    #  also, include associated reviews in the JSON response
    #  also, include associated reviews in the JSON repose

    # game.to_json(include: { reviews: { include: :user} })

    # We can also be more selective about the attributes returned from each model with the only option

    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end

end
