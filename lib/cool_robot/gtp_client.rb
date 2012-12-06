module CoolRobot
  class GtpClient

    def initialize options = {}
      engine = ENV["GTP_ENGINE"] || 'gnugo'

      @adapter = 
        if engine =~ /gnugo/i
          GnugoAdapter.new
        elsif engine =~ /fuego/i
          FuegoAdapter.new
        #elsif engine =~ /pachi/i
        #  PachiAdapter.new
        else
          raise "Unsupported GTP Engine: #{engine}"
        end
    end

    def start
      @adapter.start
    end

    def play sgf
      @adapter.play sgf
    end

  end
end

