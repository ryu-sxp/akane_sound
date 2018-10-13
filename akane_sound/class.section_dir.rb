class SectionDir < UpperSectionBase
  @dir = nil
  @playlist = nil
  @playlist_state = nil
  def initialize(x, y, w, h, col)
    super
    if @@debug_flag
      @dir = '/home/ryu/Music/Soundtracks'
    else
      @dir = @@config[:root_dir]
    end
    @dir += '/' unless @dir[-1] == '/'
    @dir = @@save_data[:cur_dir] if @@save_data[:cur_dir]
    @playlist = set_playlist(@dir)
  end

  def update
  end
  
  def draw
    super
  end

  #return: Array of Hash { filename: , dir_flag:, duration: }
  def set_playlist(dir)
    ar = Array.new
    Dir.chdir(dir)

    dir_contents_dir = Dir.entries(dir).select do |entry|
      if dir == @@config[:root_dir]
        File.directory? File.join(dir, entry) and
          !(entry == '.' || entry == '..')
      else
        File.directory? File.join(dir, entry) and
          !(entry == '.')
      end
    end
    p dir_contents.to_s
    return ar
  end
end
