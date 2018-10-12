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
    @playlist = set_playlist(@dir)
  end

  def update
  end
  
  def draw
    super
  end

  #return: Hash { filename: , dir_flag:, duration: }
  def set_playlist(dir)
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
    return dir_contents
  end
end
