require "grape"

module Twitter
  class API < Grape::API
    mount Twitter::API_V1
    mount Twitter::API_V2
  end
end