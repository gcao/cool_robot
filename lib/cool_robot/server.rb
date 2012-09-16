module CoolRobot
  class Server
    def initialize
      @gocool_client = GocoolClient.new
      @gtp_client = GtpClient.new
    end

    def run
    end
  end
end

