module CoolRobot
  class Main
    attr :gocool_client
    attr :gtp_client

    DEFAULT_SLEEP_TIME = 5

    def initialize
      @gocool_client = GocoolClient.new
      @gtp_client    = GtpClient.new
    end

    def run
      while true
        games = @gocool_client.games
        games.each do |game|
          puts "Gocool Client found game #{game["id"]}"
          
          sgf = @gocool_client.game_sgf game
          color, x, y = *@gtp_client.play(sgf)

          puts "Gocool Client is sending move [#{color}, #{x}, #{y}] to server"
          @gocool_client.play game, color, x, y
        end

        invitations = @gocool_client.invitations
        invitations.each do |invitation|
          puts "Gocool Client found invitation #{invitation["id"]}"
          @gocool_client.accept invitation
        end

        sleep sleep_time
      end
    end

    def sleep_time
      (ENV["SLEEP_TIME"] || DEFAULT_SLEEP_TIME).to_i
    end

  end
end

