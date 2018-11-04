class ViewBase < AkaneSound
  def initialize(x, y, w, h, col)
    @view_base = SDL2::Rect[x, y, w, h]
    @col = col
  end

  def update
  end

  def update_size(x, y, w, h)
    @view_base = SDL2::Rect[x, y, w, h]
  end

  def draw
    @@renderer.viewport = @view_base
    @@renderer.draw_color = [@col[:red],
                             @col[:green],
                             @col[:blue],
                             @col[:alpha]]
    #TODO viewport?

  end
end

