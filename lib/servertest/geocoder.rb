module Geocoder
  def self.search(*_args)
    # A point in Bury, Greater Manchester
    [OpenStruct.new(data: { "lat" => "53.596", "lon" => "-2.29" })]
  end
end
