require 'rails_helper'

RSpec.describe Image, type: :model do
  include_context "db_scope"

  context "build valid image" do
    it "default image created with random caption" do
      image=FactoryGirl.build(:image)
      expect(image.creator_id).to_not be_nil
      expect(image.save).to be true
    end

    it "image with User and non-nil caption" do
      user=FactoryGirl.create(:user)
      image=FactoryGirl.build(:image, :with_caption, :creator_id=>user.id)
      expect(image.creator_id).to eq(user.id)
      expect(image.caption).to_not be_nil
      expect(image.save).to be true      
    end

    it "image with explicit nil caption" do
      image=FactoryGirl.build(:image, caption:nil)
      expect(image.creator_id).to_not be_nil
      expect(image.caption).to be_nil
      expect(image.save).to be true
    end
  end

  context "include or exclude from index queries" do
    it "include images with ids from a list" do
      image_ids = (1..5).map { |idx| FactoryGirl.create(:image).id}
      expect(Image.including([image_ids[0], image_ids[3], image_ids[4]]).size).to eq(3)
    end

    it "exclude images with ids from a list" do
      image_ids = (1..5).map { |idx| FactoryGirl.create(:image).id}
      expect(Image.excluding([image_ids[0], image_ids[3], image_ids[4]]).size).to eq(2)
    end
  end
end
