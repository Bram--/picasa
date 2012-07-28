# -*- encoding: utf-8 -*-
require "spec_helper"

describe Picasa::Album do
  describe "#list" do
    before do
      response = fixture_file("album/album-list.txt")
      FakeWeb.register_uri(:get, "https://picasaweb.google.com/data/feed/api/user/w.wnetrzak", :response => response)
      @album = Picasa::Album.new("w.wnetrzak")
    end

    it "should have album entries" do
      @album.list["entry"].size.should == 2
    end

    it "should have album attributes" do
      album_1 = @album.list["entry"][0]

      album_1["id"][1].should     eql "5243667126168669553"
      album_1["title"].should     eql "test2"
      album_1["numphotos"].should eql "3"
    end

    it "should have slideshow" do
      @album.list["link"][2]["type"].should     eql "application/x-shockwave-flash"
      @album.list["link"][2]["href"].should_not be_nil
    end

    it "should have author" do
      @album.list["author"]["name"].should eql "Wojciech Wnętrzak"
    end
  end

  describe "#show" do
    before do
      response = fixture_file("album/album-show.txt")
      FakeWeb.register_uri(:get, "https://picasaweb.google.com/data/feed/api/user/w.wnetrzak/albumid/5243667126168669553", :response => response)
      @album = Picasa::Album.new("w.wnetrzak")
    end

    it "should have slideshow" do
      albums =  @album.show("5243667126168669553")
      albums["link"][2]["type"].should eql "application/x-shockwave-flash"
      albums["link"][2]["href"].should_not be_nil
    end

    it "should have photo entries" do
      @album.show("5243667126168669553")["entry"].size.should == 3
    end

    it "should have author" do
      @album.show("5243667126168669553")["author"]["name"].should eql "Wojciech Wnętrzak"
    end

    it "should have alias to photos" do
      @album.show("5243667126168669553").should eql @album.photos("5243667126168669553")
    end

    it "should have thumbnails" do
      thumbnails = @album.show("5243667126168669553")["entry"][0]["group"]["thumbnail"]

      thumbnails.size.should == 3
      thumbnails[0]["url"].should_not be_nil
      thumbnails[0]["height"].should eql"47"
      thumbnails[0]["width"].should eql "72"
    end

    it "should have public url" do
      expected = "https://lh4.googleusercontent.com/-O0AOpTAPGBQ/SMU_j4ADl9I/AAAAAAAAAFs/DRnmROPuRVU/Kashmir%252520range.jpg"
      @album.show("5243667126168669553")["entry"][0]["content"]["src"].should eql expected
    end

    # tag

    it "should have one photo only with given tag" do
      response = fixture_file("album/album-show-with-tag-and-one-photo.txt")
      FakeWeb.register_uri(:get, "https://picasaweb.google.com/data/feed/api/user/w.wnetrzak/albumid/5243667126168669553?tag=ziemniaki", :response => response)
      feed = @album.show("5243667126168669553", :tag => "ziemniaki")

      feed["entry"].should be_a Hash
    end

    it "should have array of photos with given tag" do
      response = fixture_file("album/album-show-with-tag-and-many-photos.txt")
      FakeWeb.register_uri(:get, "https://picasaweb.google.com/data/feed/api/user/w.wnetrzak/albumid/5243667126168669553?tag=nice", :response => response)
      feed = @album.show("5243667126168669553", :tag => "nice")

      feed["entry"].should be_a Array
      feed["entry"].size.should == 2
    end

    # max_results

    it "should have array of photos with given tag" do
      response = fixture_file("album/album-show-with-max-results.txt")
      FakeWeb.register_uri(:get, "https://picasaweb.google.com/data/feed/api/user/w.wnetrzak/albumid/5243667126168669553?max-results=2", :response => response)
      feed = @album.show("5243667126168669553", :max_results => 2)

      feed["entry"].should be_a Array
      feed["entry"].size.should == 2
    end
  end
end
