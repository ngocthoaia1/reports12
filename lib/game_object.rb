class GameObject
  attr_reader :x, :y

  def destroy
    @destroyed = true
  end

  def destroy?
    @destroyed ? true : false
  end

  def exploding?
    @exploding
  end

  def explode
    @explosion = Explosion.new @window, self
    @exploding = true
  end
end
