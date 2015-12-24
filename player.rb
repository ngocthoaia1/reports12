class Player
  def initialize
    @image = Gosu::Image.new("media/starfighter.bmp")
    @beep = Gosu::Sample.new("media/beep.wav")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle = -90
  end

  def turn_right
    @angle = 90
  end

  def turn_up
    @angle = 0
  end

  def turn_down
    @angle = 180
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.4)
    @vel_y += Gosu::offset_y(@angle, 0.4)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    padding = 16
    @x = 640 - padding if @x > 640 - padding
    @y = 480 - padding if @y > 480 - padding
    @x = padding if @x < padding
    @y = padding if @y < padding

    @vel_x *= 0.96
    @vel_y *= 0.96
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, 0.7, 0.7)
  end

  def score
    @score
  end

  def collect_stars(stars)
    stars.reject! do |star|
      if Gosu::distance(@x, @y, star.x, star.y) < 25 then
        @score += 10
        @beep.play
        true
      else
        false
      end
    end
  end
end
