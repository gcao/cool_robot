require 'go/gtp'
require 'tempfile'

module CoolRobot
  class GtpClient

    # log settings
    BEFORE_START_ROBOT     = ["before-start-robot"    , Logger::DEBUG]
    AFTER_START_ROBOT      = ["after-start-robot"     , Logger::TRACE]
    BEFORE_PLAY            = ["before-play"           , Logger::INFO ]
    WRITE_SGF_TO_TEMP_FILE = ["write-sgf-to-temp-file", Logger::TRACE]
    BEFORE_LOAD_SGF        = ["before-load-sgf"       , Logger::DEBUG]
    AFTER_LOAD_SGF         = ["after-load-sgf"        , Logger::TRACE]
    SHOW_BOARD             = ["show-board"            , Logger::TRACE]
    BEFORE_GEN_MOVE        = ["before-gen-move"       , Logger::INFO ]
    AFTER_GEN_MOVE         = ["after-gen-move"        , Logger::INFO ]

    DEFAULT_GNUGO_DIR = "/Users/gcao/proj/gnugo/interface"

    POSITIONS = "ABCDEFGHJKLMNOPQRST"

    attr :gtp

    def initialize options = {}
      @logger = Logger.new("GTP Client")

      options[:directory] = ENV["GNUGO_DIR"] || DEFAULT_GNUGO_DIR unless options[:dir]
      
      @logger.log BEFORE_START_ROBOT, options
      @gtp = Go::GTP.run_gnugo options
      @logger.log AFTER_START_ROBOT
    end

    # Return color and coordinates of generated move, e.g. D1 => [4, 0]
    def play sgf
      @logger.log BEFORE_PLAY, sgf
      @logger.log WRITE_SGF_TO_TEMP_FILE
      file = Tempfile.new('sgf')
      file.write(sgf)
      file.close

      @logger.log BEFORE_LOAD_SGF
      color = @gtp.loadsgf(file.path) or abort "Failed to load sgf: #{sgf}"
      @logger.log AFTER_LOAD_SGF, "#{color} plays next"
      @logger.log SHOW_BOARD, "\n#{@gtp.showboard}"

      @logger.log BEFORE_GEN_MOVE, "The robot is thinking..."
      move = @gtp.genmove(color)
      @logger.log AFTER_GEN_MOVE, "The robot played #{move}"
      @logger.log SHOW_BOARD, "\n#{@gtp.showboard}"

      x = POSITIONS.index(move[0])
      y = move[1..-1].to_i - 1
      [color, x, y]
    end

  end
end

