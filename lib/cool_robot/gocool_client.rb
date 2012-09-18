require 'httparty'

module CoolRobot
  class GocoolClient
    include HTTParty

    # log settings
    INITIALIZED              = ["initialized"             , Logger::INFO ]
    BEFORE_CHECK_GAMES       = ["before-check-games"      , Logger::TRACE]
    AFTER_CHECK_GAMES        = ["check-games"             , Logger::INFO ]
    BEFORE_LOAD_SGF          = ["before-load-sgf"         , Logger::TRACE]
    AFTER_LOAD_SGF           = ["load-sgf"                , Logger::DEBUG]
    BEFORE_SEND_MOVE         = ["before-send-move"        , Logger::INFO ]
    AFTER_SEND_MOVE          = ["after-send-move"         , Logger::INFO ]
    BEFORE_CHECK_INVITATIONS = ["before-check-invitations", Logger::INFO ]
    AFTER_CHECK_INVITATIONS  = ["after-check-invitations" , Logger::INFO ]
    BEFORE_ACCEPT_INVITATION = ["before-accept-invitation", Logger::DEBUG]
    AFTER_ACCEPT_INVITATION  = ["accept-invitation"       , Logger::INFO ]

    base_uri ENV["GOCOOL_SERVER"] || "http://localhost:5000"

    attr :username

    def initialize options = {}
      @logger = Logger.new("Gocool Client")

      @username = options[:username] || ENV["GOCOOL_USERNAME"] || "robot"
      @password = options[:password] || ENV["GOCOOL_PASSWORD"] || "please"

      @logger.log(INITIALIZED, url: self.class.base_uri, username: @username, password: @password)
    end

    # Return games that wait for my move
    def games
      @logger.log(BEFORE_CHECK_GAMES)
      parsed_response = get_and_parse("/api/games/my_turn.json")
      games = parsed_response["body"]
      @logger.log(AFTER_CHECK_GAMES, "Found #{games.size} games")
      games
    end

    def game_sgf game
      @logger.log(BEFORE_LOAD_SGF, game["id"])
      response = get "/api/games/#{game["id"]}.sgf"
      @logger.log(AFTER_LOAD_SGF, game["id"], response.body)
      response.body
    end

    def send_move game, color, x, y
      @logger.log(BEFORE_SEND_MOVE, game["id"], color, x, y)
      get_and_parse "/api/games/#{game["id"]}/play", color: color, x: x, y: y
      @logger.log(AFTER_SEND_MOVE, 'success')
    end

    def invitations
      @logger.log(BEFORE_CHECK_INVITATIONS)
      parsed_response = get_and_parse "/api/invitations.json"
      invitations = parsed_response["body"]
      @logger.log(AFTER_CHECK_INVITATIONS, "Found #{invitations.size} invitations")
      invitations
    end

    # Return ID of created game
    def accept invitation
      @logger.log(BEFORE_ACCEPT_INVITATION)
      parsed_response = get_and_parse "/api/invitations/#{invitation["id"]}/accept"
      game_id = parsed_response["body"]["game_id"]
      @logger.log(AFTER_ACCEPT_INVITATION, "Created game #{game_id}")
      game_id

      #response = self.class.post "/api/invitations/#{invitation["id"]}/accept"

      #raise response.inspect unless response.parsed_response['status'] == 'success'

      #response.parsed_response["body"]
    end

    private

    def get url, params = {}
      params.merge! login: @username, password: @password

      self.class.get "#{url}?#{params.map{|k, v| "#{k}=#{v}"}.join("&")}"
    end

    def get_and_parse url, params = {}
      response = get url, params

      raise response.inspect unless response.parsed_response['status'] == 'success'

      response.parsed_response
    end

  end
end

