class SectionDir < UpperSectionBase
  @view = nil
  @dir = nil
  @playlist = nil
  @playlist_state = nil
  @cache_flag = false
  @element_h = nil
  @offset = nil
  def initialize(x, y, w, h, col)
    super
    if @@debug_flag
      @dir = '/media/winhdd/music/Unsorted/'
      #@dir = '/home/ryu/Music/'
    else
      @dir = @@config[:root_dir]
    end
    @dir = @@save_data[:cur_dir] if @@save_data[:cur_dir]
    @playlist = set_playlist(@dir, false)
    @element_h = (@@config[:font_size] * 1).to_i
    @offset = @element_h / 2
    @view = SDL2::Rect[@offset,
                       @offset,
                       @view_base.w - @element_h,
                       @view_base.h - @element_h]
  end

  def update
  end
  
  def draw
    super
    # draw border
    @@renderer.viewport = @view
    @@renderer.draw_blend_mode = SDL2::BlendMode::BLEND
    @@renderer.draw_color = [@@config[:fg_color][:red],
                             @@config[:fg_color][:green],
                             @@config[:fg_color][:blue],
                             @@config[:fg_color][:alpha]]
    @@renderer.draw_rect(SDL2::Rect[0, 0, @view.w, @view.h])
    # draw item list
    i = 0
    @playlist.each do |item|
      txt = @@font.render_blended(item[:filename],
                                  Util.to_col_ar(
                                    @@config[:text_color]))
      @@renderer.copy(@@renderer.create_texture_from(txt),
        nil, SDL2::Rect.new(4,
                                                             0+(i*@element_h)+(@element_h/2)-(txt.h/2),
                            txt.w,
                            txt.h))
      txt.destroy
      i += 1
    end
  end

  #return: Array of Hash { filename: , dir_flag:, duration: }
  def set_playlist(dir, refresh)
    ar = Array.new
    dir_contents_dir = Dir.entries(dir).select do |entry|
      if dir == @@config[:root_dir]
        File.directory?(File.join(dir, entry)) and
          !(entry == '.' || entry == '..')
      else
        File.directory?(File.join(dir, entry)) and
          !(entry == '.')
      end
    end
    dir_contents_dir.each do |entry|
      ar.push({ filename: entry+'/', dir_flag: true, duration: nil, bps: nil,
                br: nil })
    end
    dir_contents_file = Dir.entries(dir).select do |entry|
      !File.directory?(File.join(dir, entry)) and
        (/\.mp3|ogg|m4a|wav|mid|flac\z/ === entry)
    end
    dir_contents_file.each do |entry|
      dur = %x( mediainfo --Inform="Audio;%Duration%" "#{dir+entry}" )
      bps = %x( mediainfo --Inform="Audio;%BitRate%" "#{dir+entry}" )
      br  = %x( mediainfo --Inform="Audio;%BitRate_Mode%" "#{dir+entry}" )
      ar.push({ filename: entry, dir_flag: false, duration: dur.to_i,
                bps: bps.to_i, br: br[0..2] })
    end
    p ar.to_s if @@debug_flag
    return ar
  end
end
