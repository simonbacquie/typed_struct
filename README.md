This allows you to define a data structure with a set of attributes, restricted to a specific type. Attributes can be required, or optional.

First, create a class that extends TypedStruct:
```
class ImageMetadata < TypedStruct>
```

Then, define the attributes that you need:
```
  attribute :title,        String, required: true
  attribute :description,  String
  attribute :pixel_width,  Fixnum
  attribute :pixel_height, Fixnum
  attribute :dpi,          Fixnum
  attribute :taken_at,     Time,   required: true
```

See the example class, `image_metadata.rb`.

To create an instance of the struct:
```
ImageMetadata.new(title: "My Image", taken_at: Time.now)
```

If a type doesn't match, you'll get:
```
ImageMetadata.new(title: 123, taken_at: '2015-09-06')
TypeError: Attribute 'title' must be of type String, Attribute 'taken_at' must be of type Time
```

If any required fields are missing, you'll get:
```
ImageMetadata.new(pixel_width: 640, pixel_height: 480)
ArgumentError: Attribute 'title' is required, Attribute 'taken_at' is required
```

Any extra attributes passed in to the constructor will be ignored.

To run specs:
```
ruby -Ilib:test test/minitest/*
```

I chose to set this up as a class that extends a base class, so that it'd behave similar to ActiveRecord where you define relationships and properties on the object, in a declarative syntax at the top of the file. I chose to ignore fields that are not defined as attributes, so that the object can be used to filter out unwanted fields from an existing Hash.
