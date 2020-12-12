module Helper
    def upload file
        file = File.open(file)
        file_data = file.readlines.map(&:chomp)
        file.close
        file_data
    end
end