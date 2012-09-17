module CoolRobot
  class Logger
    # Log levels
    ERROR = 50
    WARN  = 40
    INFO  = 30
    DEBUG = 20
    TRACE = 10

    DEFAULT_VISIBLE_LEVEL = INFO

    # Actions
    GAME_SGF          = ["game-sgf"  , INFO]

    def initialize context
      @context = context
    end

    def level
      return @level if @level

      if (level_string = ENV['ROBOT_LOG_LEVEL'])
        @level = string_to_level(level_string)
      else
        @level = DEFAULT_VISIBLE_LEVEL
      end
    end

    def log action_level, *args
      action, level = *action_level

      return if self.level > level

      puts level_to_string(level) << action << " | " << args.join(" | ")
    end

    def visible? level
      self.level <= level
    end

    private

    def level_to_string level
      case level
      when ERROR then "ERROR"
      when WARN  then "WARN "
      when INFO  then "INFO "
      when DEBUG then "DEBUG"
      when TRACE then "TRACE"
      else level.to_s
      end
    end

    def string_to_level level_string
      return DEFAULT_VISIBLE_LEVEL if level_string.nil? or level_string.strip == ''

      case level_string.downcase
      when 'error' then ERROR
      when 'warn'  then WARN
      when 'info'  then INFO
      when 'debug' then DEBUG
      when 'trace' then TRACE
      end
    end
  end
end

