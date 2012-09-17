module CoolRobot
  class App

    # log settings
    STARTED = ["started", Logger::INFO]
    SLEEP   = ["sleep"  , Logger::TRACE]

    DEFAULT_SLEEP_TIME = 5

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
        games = @gocool_client.games
        games.each do |game|
          sgf = @gocool_client.game_sgf game
          color, x, y = *@gtp_client.play(sgf)

          @gocool_client.send_move game, color, x, y
        end

        invitations = @gocool_client.invitations
        invitations.each do |invitation|
          @gocool_client.accept invitation
        end

        @logger.log SLEEP, sleep_time
        sleep sleep_time
      end
    end

    def sleep_time
      (ENV["SLEEP_TIME"] || DEFAULT_SLEEP_TIME).to_i
    end

  end
end

