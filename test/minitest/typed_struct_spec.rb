require_relative "../../typed_struct.rb"
require_relative "../../image_metadata.rb"
require "minitest/autorun"

describe TypedStruct do

  it "fails with ArgumentError when required attributes are missing" do
    params = {pixel_width: 640, pixel_height: 480}
    ->{ ImageMetadata.new(params) }.must_raise ArgumentError
  end

  it "fails with TypeError when attributes have the wrong type" do
    params = {title: "Test", taken_at: "2015-09-06"}
    ->{ ImageMetadata.new(params) }.must_raise TypeError
  end

  it "has accessible attributes after validation passes" do
    params = {title: "Test", taken_at: Time.now}
    struct = ImageMetadata.new(params)
    struct.title.must_equal "Test"
    struct.taken_at.wont_be_nil
  end

  it "has settable attributes after validation passes" do
    params = {title: "Test", taken_at: Time.now}
    struct = ImageMetadata.new(params)
    struct.title = "Modified Title"
    struct.title.must_equal "Modified Title"
  end

  it "checks the type when using the assignment methods" do
    params = {title: "Test", taken_at: Time.now}
    struct = ImageMetadata.new(params)
    ->{ struct.title = 123 }.must_raise TypeError
  end

  it "ignores attributes passed that are not defined in the class" do
    params = {title: "Test", taken_at: Time.now, bogus_attribute: 123}
    struct = ImageMetadata.new(params)
    ->{ struct.bogus_attribute }.must_raise NoMethodError
  end

end
