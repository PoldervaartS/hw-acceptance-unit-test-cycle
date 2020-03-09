require 'rails_helper'

describe MoviesController do
  
  describe 'Search movies by the same director' do
      it 'should call Movie.similar_movies' do
      expect(Movie).to receive(:similar_movies).with('Aladdin')
      get :search, { title: 'Aladdin' }
    end

    it 'should assign similar movies if director exists' do
      movies = ['Seven', 'The Social Network']
      Movie.stub(:similar_movies).with('Seven').and_return(movies)
      get :search, { title: 'Seven' }
      expect(assigns(:similar_movies)).to eql(movies)
    end

    it "should redirect to home page if director isn't known" do
      Movie.stub(:similar_movies).with('No name').and_return(nil)
      get :search, { title: 'No name' }
      expect(response).to redirect_to(root_url)
    end
  end
  describe 'POST #create' do
    it 'creates a new movie' do
      expect {post :create, movie: FactoryGirl.attributes_for(:movie)
      }.to change { Movie.count }.by(1)
    end

    it 'redirects to the movie index page' do
      post :create, movie: FactoryGirl.attributes_for(:movie)
      expect(response).to redirect_to(movies_url)
    end
  end


  describe 'PUT #update' do
    let(:movie1) { FactoryGirl.create(:movie) }
    before(:each) do
      put :update, id: movie1.id, movie: FactoryGirl.attributes_for(:movie, title: 'Modified')
    end

    it 'updates an existing movie' do
      movie1.reload
      expect(movie1.title).to eql('Modified')
    end

    it 'redirects to the movie page' do
      expect(response).to redirect_to(movie_path(movie1))
    end
  end

  describe 'DELETE #destroy' do
    let!(:movie1) { FactoryGirl.create(:movie) }

    it 'destroys a movie' do
      expect { delete :destroy, id: movie1.id
      }.to change(Movie, :count).by(-1)
    end

    it 'redirects to movies#index after destroy' do
      delete :destroy, id: movie1.id
      expect(response).to redirect_to(movies_path)
    end
  end
end