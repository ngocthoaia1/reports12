require './player_ship'
require './lib/game_object'

class Ship < GameObject
  def initialize game, player_ship
    @game = game
    @image = Gosu::Image.new("media/ship.png")
    @boom = Gosu::Sample.new("media/boom.wav")
    @player_ship = player_ship
    loop do
      @x = rand(@game.width)
      @y = rand(@game.height)
      break if Gosu::distance(@x, @y, @player_ship.x, @player_ship.y) > 200
    end

    @vel_x = @vel_y = 0.5
    @angle = 0
    @time_to_live = 5 + rand(30) # second
    @time_start = Time.now
  end

  def alive?
    (Time.now - @time_start).to_i <= @time_to_live && !@destroyed
  end

  def time_live
    (Time.now - @time_start).to_i
  end

  def speed
    case
    when time_live < 10
      return 1.5
    when time_live < 20
      return 2.5
    else
      return 3.5
    end
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def accelerate
    @vel_x = Gosu::offset_x(@angle, speed)
    @vel_y = Gosu::offset_y(@angle, speed)
  end

  def move
    return if @player_ship.exploding?
    accelerate
    @x += @vel_x
    @y += @vel_y
    padding = 16
    @x = [@game.width - padding, @x].min
    @y = [@game.height - padding, @y].min
    @x = [padding, @x].max
    @y = [padding, @y].max

    set_angle @x, @y, @player_ship.x, @player_ship.y
    attack
  end

  def set_angle(x1, y1, x2, y2)
    @angle = Math.atan2(y2 - y1, x2 - x1) / Math::PI * 180 + 90
  end

  def draw
    if exploding?
      @explosion.update
      @explosion.draw
    else
      @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, 0.5, 0.5)
    end
  end

  def attack
    if Gosu::distance(@x, @y, @player_ship.x, @player_ship.y) < 25
      @player_ship.explode
      self.explode
    end
  end
end
