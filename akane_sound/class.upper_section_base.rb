class UpperSectionBase < ViewBase
  attr_accessor :max_elements
  def initialize(x, y, w, h, col)
    super
    @view = nil
    @element_h = nil
    @offset = nil
    @max_elements = 0
    @element_h = (@@config[:font_size] * @@config[:line_height_mod]).to_i
    @offset = @element_h
    @max_elements = 0
    set_view
    @txt_color   = Util.to_col_ar(@@config[:text_color])
    @txt_col_dis = Util.to_col_ar(@@config[:text_color_disabled])
    @txt_color_sel   = Util.to_col_ar(@@config[:text_color_selected])
    @elements = Array.new
    @title = @@font.render_blended(@title, @txt_color)
    @title_rect = SDL2::Rect[8, @element_h/2-@title.h/2, @title.w, @title.h]

    update_element_strings
    set_page
    update_element_positions
  end

  def update
    if @focus_flag
      if @@inp.down == 1 || @@inp.down >= 20
        if @@inp.down == 1
          @pointer = (@pointer+1) % @elements.length
          set_page
          update_element_positions
        elsif @@inp.down == 22
          @pointer = (@pointer+1) % @elements.length
          set_page
          update_element_positions
          @@inp.down = 20
        end
      end
      if @@inp.up == 1 || @@inp.up >= 20
        if @@inp.up == 1
          @pointer = (@pointer+(@elements.length-1)) % @elements.length
          set_page
          update_element_positions
        elsif @@inp.up == 22
          @pointer = (@pointer+(@elements.length-1)) % @elements.length
          set_page
          update_element_positions
          @@inp.up = 20
        end
      end
      if @@inp.pagedown == 1
        @pointer = @max_elements*@page
        @pointer = @elements.length-1 if @pointer > @elements.length-1
        set_page
        update_element_positions
      end
      if @@inp.pageup == 1
        @pointer = @max_elements*(@page-2)
        @pointer = 0 if @pointer < 0
        set_page
        update_element_positions
      end
      if @@inp.first == 1
        @pointer = 0
        set_page
        update_element_positions
      end
      if @@inp.last == 1
        @pointer = @elements.length-1
        set_page
        update_element_positions
      end
      if @@inp.accept == 1
        #Util.p (@elements.length.to_f/@max_elements.to_f).ceil.to_s
      end
    end
  end

  def update_size(x, y, w, h)
    super
    @max_elements = 0
    set_view
    set_page
    update_element_strings
    update_element_positions
  end

  def update_element_positions
    j = 0
    i = @max_elements*(@page-1)
    k = -1

    @elements.each do |e|
      k += 1
      next if k < i
      unless @playlist[i][:dir_flag] || @playlist[i][:pl_flag]
        overshoot = ((@view.w-8)-@elements[i].dur.w-4)
        unless i == @pointer
          if @elements[i].txt.w >= overshoot
            sprite_w = @elements[i].txt.w-(@elements[i].txt.w-overshoot)
          else
            sprite_w = @elements[i].txt.w
          end
          sprite_h = @elements[i].txt.h
        else
          if @elements[i].txt_bld.w >= overshoot
            sprite_w = @elements[i].txt_bld.w-(@elements[i].txt_bld.w-overshoot)
          else
            sprite_w = @elements[i].txt_bld.w
          end
          sprite_h = @elements[i].txt_bld.h
        end
      else
        unless i == @pointer
          sprite_w = @elements[i].txt.w
          sprite_h = @elements[i].txt.h
        else
          sprite_w = @elements[i].txt_bld.w
          sprite_h = @elements[i].txt_bld.h
        end
      end
      y = (0+(j*@element_h))+((@element_h/2)-(sprite_h/2))
      @elements[i].txt_src = SDL2::Rect[0, 0, sprite_w, sprite_h]
      @elements[i].txt_dst = SDL2::Rect[4, y, sprite_w, sprite_h]
      @elements[i].bg_rect = SDL2::Rect[0, j*@element_h, @view.w, @element_h]
      unless @playlist[i][:dir_flag] || @playlist[i][:pl_flag]
        @elements[i].dur_dst = SDL2::Rect[(@view.w-@elements[i].dur.w)-4, y,
                                          @elements[i].dur.w,
                                          @elements[i].dur.h]
      end
      i+= 1
      j+= 1


    end
  end
=begin
  def update_element_positions
    j = 0
    i = @max_elements*(@page-1)
    Util.p i.to_s

    @playlist.each do |item|
      unless item[:dir_flag]
        overshoot = ((@view.w-8)-@elements[i].dur.w-4)
        unless i == @pointer
          if @elements[i].txt.w >= overshoot
            sprite_w = @elements[i].txt.w-(@elements[i].txt.w-overshoot)
          else
            sprite_w = @elements[i].txt.w
          end
          sprite_h = @elements[i].txt.h
        else
          if @elements[i].txt_bld.w >= overshoot
            sprite_w = @elements[i].txt_bld.w-(@elements[i].txt_bld.w-overshoot)
          else
            sprite_w = @elements[i].txt_bld.w
          end
          sprite_h = @elements[i].txt_bld.h
        end
      else
        unless i == @pointer
          sprite_w = @elements[i].txt.w
          sprite_h = @elements[i].txt.h
        else
          sprite_w = @elements[i].txt_bld.w
          sprite_h = @elements[i].txt_bld.h
        end
      end
      y = (0+(j*@element_h))+((@element_h/2)-(sprite_h/2))
      @elements[i].txt_src = SDL2::Rect[0, 0, sprite_w, sprite_h]
      @elements[i].txt_dst = SDL2::Rect[4, y, sprite_w, sprite_h]
      @elements[i].bg_rect = SDL2::Rect[0, j*@element_h, @view.w, @element_h]
      unless item[:dir_flag]
        @elements[i].dur_dst = SDL2::Rect[(@view.w-@elements[i].dur.w)-4, y,
                                          @elements[i].dur.w,
                                          @elements[i].dur.h]
      end
      i+= 1
      j+= 1
      break if i >= @playlist.length
    end
  end
=end

  def update_element_strings
    @border = SDL2::Rect[@view.x-1, @view.y-1, @view.w+2, @view.h+2]
    i = 0
    txtcol = (@focus_flag) ? @txt_color : @txt_col_dis
    @elements.each { |e| e.destroy }
    @elements.clear
    @playlist.each do |item|
      el = Element.new
      unless item[:dir_flag]
        str = String.new
        unless item[:artist].empty?
          str = item[:artist]+' - '
        end
        unless item[:title].empty?
          str += item[:title]
        else
          str += item[:filename]
        end
        unless item[:album].empty?
          str += ' ('+item[:album]+')'
        end
        el.dur = @@font_bold.render_blended(item[:tag], txtcol)
      else
        str = item[:filename]
      end
      el.txt = @@font.render_blended(str, txtcol)
      el.txt_bld = @@font_bold.render_blended(str, txtcol)
      el.txt_sel = @@font.render_blended(str, @txt_color_sel)
      el.txt_sel_bld = @@font_bold.render_blended(str, @txt_color_sel)

      @elements.push(el)
      i += 1
    end
  end

  def draw
    super

    @@renderer.viewport = @view_base
    @@renderer.fill_rect(SDL2::Rect[0,
                                    0,
                                    @view_base.w,
                                    @view_base.h])
    # draw border
    @@renderer.viewport = @border
    @@renderer.draw_blend_mode = SDL2::BlendMode::BLEND
    @@renderer.draw_color = [@@config[:fg_color][:red],
                             @@config[:fg_color][:green],
                             @@config[:fg_color][:blue],
                             @@config[:fg_color][:alpha]]
    @@renderer.draw_rect(SDL2::Rect[0, 0, @border.w, @border.h])
    @@renderer.viewport = @view_base
    # draw title
    @@renderer.copy(@@renderer.create_texture_from(@title), nil, @title_rect)
    
    # draw item list
    @@renderer.viewport = @view
    i = @max_elements*(@page-1)
    j = -1
    @elements.each do |el|
      j +=1
      next if j < i
      txt = nil
      if @pointer == i
        if @focus_flag
          @@renderer.draw_color = [@@config[:select_bg_color][:red],
                                   @@config[:select_bg_color][:green],
                                   @@config[:select_bg_color][:blue],
                                   @@config[:select_bg_color][:alpha]]
          @@renderer.fill_rect(el.bg_rect)
        end
        case self.class.to_s
        when "SectionDir"
          if File.join(@dir_stack.join(nil), @playlist[i][:filename]) ==
              @@sound.get_play_path("left") && @focus_flag
            txt = el.txt_sel_bld
          else
            txt = el.txt_bld
          end
        when "SectionPlaylist"
          if @playlist[i][:filename] == @@sound.get_play_path("right") &&
              @focus_flag
            txt = el.txt_sel_bld
          else
            txt = el.txt_bld
          end
        end
      else
        case self.class.to_s
        when "SectionDir"
          if File.join(@dir_stack.join(nil), @playlist[i][:filename]) ==
              @@sound.get_play_path("left") && @focus_flag
            txt = el.txt_sel
          else
            txt = el.txt
          end
        when "SectionPlaylist"
          if @playlist[i][:filename] == @@sound.get_play_path("right") &&
              @focus_flag
            txt = el.txt_sel
          else
            txt = el.txt
          end
        end
      end
      @@renderer.copy(@@renderer.create_texture_from(txt), el.txt_src,
                      el.txt_dst)
      if el.dur
        @@renderer.copy(@@renderer.create_texture_from(el.dur),
                        nil, el.dur_dst)
      end
      i += 1
      break if i >= @elements.length
    end
  end

  def get_cache(dir)
    cache = get_cache_name(dir)
    if File.exist?(cache)
      ar = YAML.load(File.open(cache))
      return ar
    end
    return nil
  end

  def get_playlist(dir)
    cache = get_cache_name(dir)
    ar = Array.new
    dir_contents_dir = Dir.entries(dir).sort.select do |entry|
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
                br: nil, artist: nil, album: nil, pl_time: nil, type: nil,
                tag: nil, title: nil, pl_flag: false, sample: nil, path: nil })
    end
    dir_contents_file = Dir.entries(dir).sort.select do |entry|
      !File.directory?(File.join(dir, entry)) and
        (/\.mp3|ogg|m4a|wav|mid|flac\z/ === entry)
    end
    dir_contents_file.each do |entry|
      dur = %x( mediainfo --Inform="Audio;%Duration%" "#{dir+entry}" )
      bps = %x( mediainfo --Inform="Audio;%BitRate%" "#{dir+entry}" )
      br  = %x( mediainfo --Inform="Audio;%BitRate_Mode%" "#{dir+entry}" )
      sample  = %x( mediainfo --Inform="Audio;%SamplingRate%" "#{dir+entry}" )
      #sample2  = %x( mediainfo --Inform="Audio;%SamplingRate/String%" "#{dir+entry}" )
      artist = %x(ffprobe -loglevel error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "#{dir+entry}" )
      album = %x(ffprobe -loglevel error -show_entries format_tags=album -of default=noprint_wrappers=1:nokey=1 "#{dir+entry}" )
      title = %x(ffprobe -loglevel error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "#{dir+entry}" )
      artist.delete!("\n")
      title.delete!("\n")
      album.delete!("\n")
      pltime = Util.ms_to_time_str(dur.to_i)
      type = entry[-3..-1].upcase
      tag = '['+pltime+'|'+type+']'
      ar.push({ filename: entry, dir_flag: false, duration: dur.to_i,
                bps: bps.to_i, br: br[0..2], artist: artist, album: album,
                pl_time: pltime, type: type, tag: tag, title: title,
                pl_flag: false, sample: sample, path: dir+entry })
      #@tracks += 1
    end
    dir_contents_pl = Dir.entries(dir).sort.select do |entry|
      !File.directory?(File.join(dir, entry)) and
        (/\.apl.yaml\z/ === entry)
    end
    dir_contents_pl.each do |entry|
      ar.push({ filename: entry+'/', dir_flag: false, duration: nil, bps: nil,
                br: nil, artist: nil, album: nil, pl_time: nil, type: nil,
                tag: nil, title: nil, pl_flag: true, sample: nil, path: nil })
    end
    # write cache
    File.open(cache, 'w') { |file| file.write(ar.to_yaml) }
    ar
  end

  private

  def set_view
    @view = SDL2::Rect[@view_base.x+@offset_left,
                       @view_base.y+@offset,
                       @view_base.w - (@offset_left+@offset_right),
                       view_height]
  end

  def view_height
    height = 0
    max_h = @view_base.h - @offset*2
    while height < max_h
      height += @element_h
      @max_elements += 1
    end
    return height
  end

  def set_page
    #@page = 1 if @pointer < @max_elements-1
    @page = get_page((@max_elements), @pointer)
  end

  def get_page(max, pointer)
    page = 1
    i = 0
    while i <= pointer
      if i == max*page
        page += 1
      end
      i += 1
    end

    return page
  end

  def get_cache_name(dir)
    unless @@debug_flag
      return File.join(dir, ".akane_cache.yaml")
    else
      return File.join(dir, ".akane_cache_debug.yaml")
    end
  end
end

