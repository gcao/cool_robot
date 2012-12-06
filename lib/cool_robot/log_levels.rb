module CoolRobot
  module LogLevels
    BEFORE_START_ROBOT     = ["start-robot"           , Logger::INFO]
    AFTER_START_ROBOT      = ["after-start-robot"     , Logger::TRACE]
    BEFORE_PLAY            = ["before-play"           , Logger::INFO ]
    WRITE_SGF_TO_TEMP_FILE = ["write-sgf-to-temp-file", Logger::TRACE]
    BEFORE_LOAD_SGF        = ["before-load-sgf"       , Logger::DEBUG]
    AFTER_LOAD_SGF         = ["after-load-sgf"        , Logger::TRACE]
    SHOW_BOARD             = ["show-board"            , Logger::TRACE]
    BEFORE_GEN_MOVE        = ["before-gen-move"       , Logger::INFO ]
    AFTER_GEN_MOVE         = ["after-gen-move"        , Logger::INFO ]
  end
end

