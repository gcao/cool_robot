require 'go/gtp'
require 'tempfile'

module CoolRobot
  class GtpClient
    DEFAULT_GNUGO_DIR = "/Users/gcao/proj/gnugo/interface"

    POSITIONS = "ABCDEFGHJKLMNOPQRST"

    attr :gtp

    def initialize options = {}
      options[:directory] = ENV["GNUGO_DIR"] || DEFAULT_GNUGO_DIR unless options[:dir]
      @gtp = Go::GTP.run_gnugo options
    end

    # Return color and coordinates of generated move, e.g. D1 => [4, 0]
    def play sgf
      file = Tempfile.new('sgf')
      file.write(sgf)
      file.close

      puts "Go Robot is loading game: #{sgf}"
      color = @gtp.loadsgf(file.path) or abort "Failed to load sgf: #{sgf}"

      puts "Go Robot is thinking..."
      move = @gtp.genmove(color)
      puts "Go Robot played #{move}"
      puts @gtp.showboard

      x = POSITIONS.index(move[0])
      y = move[1..-1].to_i - 1
      [color, x, y]
    end

  end
end

