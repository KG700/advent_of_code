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

    def to_binary string
        string.to_s(2)
    end

    def to_decimal string
        string.to_i(2)
    end

    def deep_copy array
        Marshal.load(Marshal.dump(array))
    end

end