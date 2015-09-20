This allows you to define a data structure with a set of attributes, restricted to a specific type. Attributes can be required, or optional.

First, create a class that extends TypedStruct:

  class ImageMetadata < TypedStruct>

Then, define the attributes that you need:

```
  attribute :title,        String, required: true
  attribute :description,  String
  attribute :pixel_width,  Fixnum
  attribute :pixel_height, Fixnum
  attribute :dpi,          Fixnum
  attribute :taken_at,     Time,   required: true
```

See the example class.

To create an instance of the struct:

```
ImageMetadata.new(title: "My Image", taken_at: Time.now)
```

If the type doesn't match:

```
ImageMetadata.new(title: 123, taken_at: '2015-09-06')
TypeError: Attribute 'title' must be of type String, Attribute 'taken_at' must be of type Time
```

If required fields are missing:

```
ImageMetadata.new(pixel_width: 640, pixel_height: 480)
ArgumentError: Attribute 'title' is required, Attribute 'taken_at' is required
```

To run specs:

```
ruby -Ilib:test test/minitest
```
