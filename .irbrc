$:.push(File.dirname(__FILE__) + '/lib')

require 'cool_robot'

@gc = CoolRobot::GocoolClient.new 'robot', 'please'

