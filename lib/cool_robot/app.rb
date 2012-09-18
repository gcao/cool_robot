module CoolRobot
  class App

    # log settings
    STARTED = ["started", Logger::INFO]
    SLEEP   = ["sleep"  , Logger::TRACE]

    CHECK_GAMES_INTERVAL       = (ENV["CHECK_GAMES_INTERVAL"      ] || 5).to_i
    CHECK_INVITATIONS_INTERVAL = (ENV["CHECK_INVITATIONS_INTERVAL"] || 30).to_i

    attr :gocool_client
    attr :gtp_client

    def initialize
      @logger = Logger.new("CoolRobot App")
      @logger.log STARTED

      @gocool_client = GocoolClient.new
      @gtp_client    = GtpClient.new
    end

    def run
      while true
        handle_games
        handle_invitations
        sleep 1
      end
    end

    def handle_games
      return if @last_check_games_time and 
                Time.now - @last_check_games_time < CHECK_GAMES_INTERVAL

      @last_check_games_time = Time.now

      games = @gocool_client.games
      games.each do |game|
        sgf = @gocool_client.game_sgf game
        color, x, y = *@gtp_client.play(sgf)

        @gocool_client.send_move game, color, x, y
      end
    end

    def handle_invitations
      return if @last_check_invitations_time and 
                Time.now - @last_check_invitations_time < CHECK_INVITATIONS_INTERVAL

      @last_check_invitations_time = Time.now

      invitations = @gocool_client.invitations
      invitations.each do |invitation|
        @gocool_client.accept invitation
      end
    end

  end
end

