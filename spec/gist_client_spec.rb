require 'lib/gist-client'

describe Gist::Client do
  before(:each) do
     @client = Gist::Client.new('johndoe', 'password')            
  end
  
  describe '#list' do
    it "fetches a list of gists" do
      @client.stub(:get) {[]}
      @client.should_receive(:get).with("https://api.github.com/users/johndoe/gists.json")
      @client.list
    end
  end
  
  describe '#show' do
    it "gets an individual gist" do
      @client.stub(:get) {}
      @client.should_receive(:get).with("https://api.github.com/gists/123456789.json")
      @client.show(123456789)
    end
  end
  
  describe '#create' do
    it "saves a new gist" do
      @client.stub(:put){}
      @client.should_receive(:put).with(:post, 'https://api.github.com/users/johndoe/gists.json',{
        :description => "Description Here",
        :public => true,
        :files => {
          :filename => {
            :content => "Hello, World!"
          }
        }
      })
      @client.create("Hello, World!")
    end
    
    it "fails to create without a password" do
      @client = Gist::Client.new('janedoe')
      expect { @client.create("Some test content") }.to raise_error(StandardError, 'Password is required for authenticated requests')            
    end
  end
  
  describe '#update' do
    it "updates an individual gist" do
      gist = Mash.new({
        :id => 123456789,
        :description => "An Example Gist",
        :files => {
          :filenamea => {
            :content => "Hello, World!"
          }
        },
        :public => true
      })
      @client.stub(:patch) {}
      @client.should_receive(:put).with(:patch, 'https://api.github.com/gists/123456789.json', {
        :description => gist.description,
        :public => gist.public,
        :files => gist.files
      })
      @client.update(gist)
    end
    
    it "fails to update an unsaved gist" do
      gist = Mash.new({
        :description => "An Example Gist",
        :files => {
          :filenamea => {
            :content => "Hello, World!"
          }
        },
        :public => true
      })
      gist.id = nil
      expect { @client.update(gist) }.to raise_error(StandardError, 'Gist is not saved yet')
    end
    
    it "fails to update without a password" do
      @client = Gist::Client.new('janedoe')
      gist = Mash.new({
        :id => 123456789,
        :description => "An Example Gist",
        :files => {
          :filenamea => {
            :content => "Hello, World!"
          }
        },
        :public => true
      })
      expect { @client.update(gist) }.to raise_error(StandardError, 'Password is required for authenticated requests')            
    end
  end
  
  describe '#destroy' do
    it "is a pending example"
  end
end