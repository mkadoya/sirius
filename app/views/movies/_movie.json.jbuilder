json.extract! movie, :id, :title, :outline, :director, :performer, :year, :preview, :image, :article, :movie, :created_at, :updated_at
json.url movie_url(movie, format: :json)
