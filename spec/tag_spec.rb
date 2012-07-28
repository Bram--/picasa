# -*- encoding: utf-8 -*-
require "spec_helper"

describe Picasa::Album do
  describe "#list" do
    let(:tag) { Picasa::Tag.new("w.wnetrzak") }

    it "should raise argument error when photo_id passed but without album_id" do
      expect { tag.list(:photo_id => "123") }.to raise_error ArgumentError
    end

    it "should have tag entries" do
      response = fixture_file("tag/tag-list.txt")
      FakeWeb.register_uri(:get, "https://picasaweb.google.com/data/feed/api/user/w.wnetrzak?kind=tag", :response => response)

      tag.list["entry"].size.should == 2
    end

    it "should have tag entries on album" do
      response = fixture_file("tag/tag-list-album.txt")
      FakeWeb.register_uri(:get, "https://picasaweb.google.com/data/feed/api/user/w.wnetrzak/albumid/5243667126168669553?kind=tag", :response => response)
      tag.list(:album_id => "5243667126168669553")["entry"].size.should == 2
    end

    it "should have tag entries on photo" do
      response = fixture_file("tag/tag-list-photo.txt")
      FakeWeb.register_uri(:get, "https://picasaweb.google.com/data/feed/api/user/w.wnetrzak/albumid/5243667126168669553/photoid/5634470303146876834?kind=tag", :response => response)

      tag.list(:album_id => "5243667126168669553", :photo_id => "5634470303146876834")["entry"].should_not be_nil
    end
  end
end
