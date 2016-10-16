
describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect( Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
  
  describe 'adding Tmdb movie' do
    context 'with valid key' do
      it 'should call Tmdb detail' do
        expect( Tmdb::Movie).to receive(:detail).with(1).and_return({})
        allow(Tmdb::Movie).to receive(:releases).with(1).and_return(fake_results)
        Movie.create_from_tmdb(1)
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError for Tmdb detail if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:detail).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.create_from_tmdb(1) }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
end
