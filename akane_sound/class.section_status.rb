class SectionStatus < ViewBase
  def initialize(x, y, w, h, col)
    super
  end

  def update
  end
  
  def draw
    super
    @@renderer.fill_rect(SDL2::Rect[0, 0, @view.w, @view.h])
  end
end
