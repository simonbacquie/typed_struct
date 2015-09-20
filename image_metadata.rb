class ImageMetadata < TypedStruct

  attribute :title,        String, required: true
  attribute :description,  String
  attribute :pixel_width,  Fixnum
  attribute :pixel_height, Fixnum
  attribute :dpi,          Fixnum
  attribute :taken_at,     Time,   required: true

end
