class SectionStatus < ViewBase
  def initialize(x, y, w, h, col)
    super
  end

  def update
  end

  def update_size(x, y, w, h)
    super
  end
  
  def draw
    super
    @@renderer.fill_rect(SDL2::Rect[0, 0, @view_base.w, @view_base.h])
  end
end
