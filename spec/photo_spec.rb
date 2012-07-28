# -*- encoding: utf-8 -*-
require "spec_helper"

describe Picasa::Photo do
  describe "#list" do
    subject { @album.list }

    it "should be scoped to given user when user_id is present" do
      response = fixture_file("photo/photo-list-user.txt")
      FakeWeb.register_uri(:get, "https://picasaweb.google.com/data/feed/api/user/w.wnetrzak?kind=photo", :response => response)
      @album = Picasa::Photo.new("w.wnetrzak")

      @album.list["author"]["name"].should eql 'Wojciech Wnętrzak'
    end

    # without user_id

    it "should not have author when user_id not present" do
      response = fixture_file("photo/photo-list-all.txt")
      FakeWeb.register_uri(:get, "https://picasaweb.google.com/data/feed/api/user/all?kind=photo", :response => response)
      @album = Picasa::Photo.new

      @album.list["author"].should be_nil
    end

    it "should scope results to given query" do
      response = fixture_file("photo/photo-list-all-with-q.txt")
      FakeWeb.register_uri(:get, "https://picasaweb.google.com/data/feed/api/user/all?kind=photo&q=cowbell", :response => response)
      @album = Picasa::Photo.new

      @album.list(:q => "cowbell")["entry"][0]["title"].should match "cowbell"
    end
  end
end

