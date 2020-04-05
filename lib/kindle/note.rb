require 'rubygems'
require 'chronic'

module Kindle
  class Note
    attr_accessor :content
    attr_accessor :location
    attr_accessor :added

    def content
      (@content || '').strip
    end

    def self.from_kindle_format(raw_note)
      title_author, highlight, *notes = *raw_note.split("\r\n")

      note = Note.new
      location = highlight.match(/loc. (\d*)/i)       # Kindle 2nd Gen
      location ||= highlight.match(/Location (\d*)/i) # Kindle 4th Gen (touch)
      location ||= highlight.match(/\-\s您在位置\s#(\d*)/i)  # - 您在位置 #557-559的标注

      note.location = location[1].to_i if location

      # "Added on Wednesday, June 30, 2010, 10:35 PM"
      # "添加于 2020年1月18日星期六 下午8:45:07"
      added_at = highlight.match(/添加于\s(.*)/)
      if added_at
        note.added = added_at[1]
      end
      note.content = notes.join("\r\n")
      note
    end

    def <=>(other)
      location <=> other.location
    end
    
  end
end
