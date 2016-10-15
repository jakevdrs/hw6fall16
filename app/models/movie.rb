class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
 class Movie::InvalidKeyError < StandardError ; end
  
  def self.find_in_tmdb(string)
    begin
      Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
      movies = []
      Tmdb::Movie.find(string).each do |x|
        movies << {:tmdb_id => x.id, :title => x.title, :rating => self.get_rating(x.id), :release_date => x.release_date}
      end
      return movies
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end

  def self.get_rating(tmdb_id)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    rating = ''
    Tmdb::Movie.releases(tmdb_id)["countries"].each do |x|
      if x["iso_3166_1"] == "US"
        rating = x["certification"]
      end
    end
    return rating
  end
  
  def self.create_from_tmdb(tmdb_id)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    movie_attr = Tmdb::Movie.detail(tmdb_id)
    Movie.create(title: movie_attr["original_title"], rating: self.get_rating(tmdb_id), release_date: movie_attr["release_date"])
  end
  
end
