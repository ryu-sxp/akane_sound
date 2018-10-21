class Element
  attr_accessor :txt, :dur, :txt_src, :txt_dst, :dur_dst, :bg_rect, :txt_bld
  def initialize
    @txt = nil
    @dur = nil
  end

  def destroy
    @txt.destroy if @txt
    @dur.destroy if @dur
  end
end
