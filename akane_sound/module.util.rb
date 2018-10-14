module Util
  def Util.binary_copy(dst_dir, filename)
    file = File.open("./akane_sound/#{filename}", 'rb')
    contents = file.read
    file.close
    File.open(dst_dir+filename, 'wb') { |file| file.write(contents) }
  end
  def Util.p(str)
    if str.class == String
      SDL2::MessageBox.show_simple_box(SDL2::MessageBox::ERROR, "Alert",
                                       str, nil)
    end
  end
  def Util.to_col_ar(hash)
    ar = Array.new
    hash.each { |key, val| ar.push val }
    ar.pop 1
    ar
  end
end
