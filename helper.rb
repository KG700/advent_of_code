module Helper
    def upload file
        file = File.open(file)
        file_data = file.readlines.map(&:chomp)
        file.close
        file_data
    end
    def upload_line_break file
        file = File.open(file)
        file_data = file.split("\\n\\n")
        file.close
        file_data
    end
end