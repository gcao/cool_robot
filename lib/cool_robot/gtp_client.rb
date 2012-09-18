require 'go/gtp'
require 'tempfile'

module CoolRobot
  class GtpClient

    # log(settings
    BEFORE_START_ROBOT     = ["start-robot"           , Logger::INFO]
    AFTER_START_ROBOT      = ["after-start-robot"     , Logger::TRACE]
    BEFORE_PLAY            = ["before-play"           , Logger::INFO ]
    WRITE_SGF_TO_TEMP_FILE = ["write-sgf-to-temp-file", Logger::TRACE]
    BEFORE_LOAD_SGF        = ["before-load-sgf"       , Logger::DEBUG]
    AFTER_LOAD_SGF         = ["after-load-sgf"        , Logger::TRACE]
    SHOW_BOARD             = ["show-board"            , Logger::TRACE]
    BEFORE_GEN_MOVE        = ["before-gen-move"       , Logger::INFO ]
    AFTER_GEN_MOVE         = ["after-gen-move"        , Logger::INFO ]

    vendor_dir = File.expand_path(File.dirname(__FILE__) + '/../../vendor')
    platform   = "macos"

    DEFAULT_GNUGO_DIR      = File.expand_path("#{vendor_dir}/#{platform}")
    DEFAULT_GNUGO_COMMAND  = "gnugo --mode gtp 2>&1"

    attr :gtp

    def initialize options = {}
      @logger = Logger.new("GTP Client")

      dir     = ENV["GNUGO_DIR"    ] || DEFAULT_GNUGO_DIR
      command = ENV["GNUGO_COMMAND"] || DEFAULT_GNUGO_COMMAND

      @go_engine_startup_command = "#{dir}/#{command}"

      @logger.log(BEFORE_START_ROBOT, @go_engine_startup_command)
      @gtp = Go::GTP.new(IO.popen(@go_engine_startup_command, "r+"))
      @logger.log(AFTER_START_ROBOT)
    end

    # Return color and move, e.g. [white, A4]
    def play sgf
      @logger.log(BEFORE_PLAY, sgf)
      @logger.log(WRITE_SGF_TO_TEMP_FILE)
      file = Tempfile.new('sgf')
      file.write(sgf)
      file.close

      @logger.log(BEFORE_LOAD_SGF)
      color = @gtp.loadsgf(file.path) or abort "Failed to load sgf: #{sgf}"
      @logger.log(AFTER_LOAD_SGF, "#{color} plays next")
      @logger.log(SHOW_BOARD, "\n#{@gtp.showboard}")

      @logger.log(BEFORE_GEN_MOVE, "The robot is thinking...")
      move = @gtp.genmove(color)
      @logger.log(AFTER_GEN_MOVE, "The robot played #{move}")
      @logger.log(SHOW_BOARD, "\n#{@gtp.showboard}")

      [color, move]
    end

  end
end

