require 'gosu'
require './player_ship'
require './ship'
require './z_order'
require './star'
require './lib/explosion'
require './lib/game_object'

class GameWindow < Gosu::Window
  attr_accessor :game_start, :width, :height
  MAX_SHIP = 7

  def initialize
    @width = 1024
    @height = 768
    super @width, @height
    reset_game
  end

  def update
    return if @player_ship.destroy? || !game_start

    if Gosu::button_down? Gosu::KbLeft
      @player_ship.turn_left
      @player_ship.accelerate
    end
    if Gosu::button_down? Gosu::KbRight
      @player_ship.turn_right
      @player_ship.accelerate
    end
    if Gosu::button_down? Gosu::KbUp
      @player_ship.turn_up
      @player_ship.accelerate
    end

    if Gosu::button_down? Gosu::KbDown
      @player_ship.turn_down
      @player_ship.accelerate
    end
    @player_ship.move
    @player_ship.collect_stars(@stars)

    @ships.reject!{|ship| !ship.alive?}

    @ships.each{|ship| ship.move}

    if @ships.size < MAX_SHIP
      @ships << Ship.new(self, @player_ship)
    end

   if rand(100) < 4 and @stars.size < 25 then
     @stars.push Star.new(self, @star_anim)
   end
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background, 1.6, 1.6)
    @stars.each { |star| star.draw }
    @ships.each{|a| a.draw}
    @player_ship.draw
    @font.draw("Score: #{@player_ship.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    @font.draw("Time: #{time_live}", 10, 30, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    if @player_ship.destroy?
      @font.draw("GAME OVER!!!", 400, 300, ZOrder::UI, 2.5, 2.5, 0xff_ffff00)
      @font.draw("Continue (y/n) ...", 460, 360, ZOrder::UI, 1.5, 1.5, 0xff_ffff00)
    end
  end

  def button_down id
    if id == Gosu::KbEscape
      close
    end
    if @player_ship.destroy?
      if id == 28
        reset_game
      elsif id == 17
        close
      end
    else
      if id == 28 || (id >= 79 && id <= 82) && !game_start
        self.game_start = true
        @start_time = Time.now
      end
    end
  end

  def time_live
    return 0 unless @game_start
    (Time.now - @start_time).to_i
  end

  private

  def reset_game
    @game_start = false
    self.caption = "Gosu Tutorial Game"

    @background_image = Gosu::Image.new("media/space.png", :tileable => true)

    @player_ship = PlayerShip.new self
    @player_ship.warp(512, 320)
    @ships = (1..MAX_SHIP).to_a.map{Ship.new(self, @player_ship)}

    @star_anim = Gosu::Image::load_tiles("media/star.png", 25, 25)
    @stars = Array.new
    @font = Gosu::Font.new(20)
  end
end

window = GameWindow.new
window.show
