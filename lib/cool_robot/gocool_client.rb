require 'httparty'

module CoolRobot
  class GocoolClient
    include HTTParty

    base_uri ENV["GOCOOL_SERVER"] || "http://localhost:5000"

    attr :username

    def initialize options = {}
      @username = options[:username] || ENV["GOCOOL_USERNAME"] || "robot"
      @password = options[:password] || ENV["GOCOOL_PASSWORD"] || "please"
    end

    # Return games that wait for my move
    def games
      parsed_response = get("/api/games/my_turn.json")
      parsed_response["body"]
    end

    def game_sgf game
      response = self.class.get "/api/games/#{game["id"]}.sgf"
      response.body
    end

    def play game, color, x, y
      get "app/games/#{game["id"]}/play", color: color, x: x, y: y
    end

    def invitations
      parsed_response = get("/api/invitations.json")
      parsed_response["body"]
    end

    # Return ID of created game
    def accept invitation
      parsed_response = get "/api/invitations/#{invitation["id"]}/accept"
      parsed_response["body"]["game_id"]

      #response = self.class.post "/api/invitations/#{invitation["id"]}/accept"

      #raise response.inspect unless response.parsed_response['status'] == 'success'

      #response.parsed_response["body"]
    end

    private

    def get url, params = {}
      params.merge! login: @username, password: @password

      response = self.class.get "#{url}?#{params.map{|k, v| "#{k}=#{v}"}.join("&")}"

      raise response.inspect unless response.parsed_response['status'] == 'success'

      response.parsed_response
    end

  end
end

