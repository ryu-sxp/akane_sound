class SectionPlaylist < UpperSectionBase
  def initialize(x, y, w, h, col)
    @focus_flag = @@save_data[:focus_right]
    @playlist = Array.new
    super
  end

  def update
  end

  def update_size(x, y, w, h)
    super
  end
  
  def draw
    super
  end
end
