require 'spec_helper'

describe Picasa do
  it "should allow to set custom user_id" do
    Picasa.configure do |config|
      config.user_id = "john.doe"
    end

    Picasa.user_id.should eql 'john.doe'
  end

  describe "Albums" do
    before do
      @options  = {:user_id => 'Bram'}
      @albums   = Picasa::Album.new @options[:user_id]
    end

    it "Lists all the albums" do
      Picasa::Album.any_instance.expects(:list).with(@options).returns(@albums)
      Picasa.albums(@options).should eql @albums
    end

    it "Is backward compatiable" do
      @options = {:google_user => @options[:user_id]}
      Picasa::Album.any_instance.expects(:list).with(@options).returns(@albums)

      Picasa.albums(@options).should eql @albums
    end

    it "Allows nillable options" do
      Picasa::Album.any_instance.expects(:list).returns(@albums)
      Picasa.albums.should eql @albums
    end
  end

  describe "Photos" do
    before do
      @options  = {:user_id => "Bram", :album_id => "123"}
      @albums   = Picasa::Album.new @options[:user_id]
    end

    it "Lists all the albums" do
      Picasa::Album.any_instance.expects(:show).with("123", {:user_id =>"Bram"}).returns(@albums)
      Picasa.photos(@options).should eql @albums
    end

    it "Is backward compatiable" do
      @options = {:google_user => @options[:user_id], :album_id => "123"}
      Picasa::Album.any_instance.expects(:show).with("123", {:user_id =>"Bram"}).returns(@albums)

      Picasa.photos(@options).should eql @albums
    end

    it "Raises Argument error when no album id is supplied" do
      expect { Picasa.photos }.to raise_error ArgumentError
    end
  end
end
