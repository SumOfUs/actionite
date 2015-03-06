Encoding.default_external = "UTF-8"

require "cuba"

Cuba.define do
  on root do
    res.write "Hello World!"
  end
end
