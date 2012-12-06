require 'go/gtp'
require 'tempfile'

module CoolRobot
  class GnugoAdapter
    include LogLevels

    def initialize
      @logger = Logger.new('Gnugo Adapter')

      vendor_dir     = File.expand_path(File.dirname(__FILE__) + '/../../vendor')
      platform       = "macos"
      options        = ENV['GNUGO_OPTIONS']
      @start_command = File.expand_path("#{vendor_dir}/#{platform}") + "/gnugo --mode gtp #{options} 2>&1"
    end

    def start
      @logger.log(BEFORE_START_ROBOT, @start_command)
      @gtp = Go::GTP.new(IO.popen(@start_command, "r+"))
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

