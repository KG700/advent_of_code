class Passport

    attr_accessor :byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid

    def initialize
        @byr = nil # Birth year
        @iyr = nil # Issue year
        @eyr = nil # Expiration year
        @hgt = nil # Height
        @hcl = nil # Hair colour
        @ecl = nil # Eye colour
        @pid = nil # Passport ID
        @cid = nil # Country ID
    end
    
    def set_property key, value
        case key
        when "byr"
            @byr = value
        when "iyr"
            @iyr = value
        when "eyr"
            @eyr = value
        when "hgt"
            @hgt = value
        when "hcl"
            @hcl = value
        when "ecl"
            @ecl = value
        when "pid"
            @pid = value
        when "cid"
            @cid = value
        end
    end

    def valid?
        !(@byr.nil? || @iyr.nil? || @eyr.nil? || @hgt.nil? || @hcl.nil? || @ecl.nil? || @pid.nil?)
    end

end

def count_valid_passports
    passport_data = upload("day-4/passport_data.txt")

    # Create array of passport objects
    passport_list = []
    passport_index = 0
    passport_data.each do |row|
        passport_index += 1 if row == ""
        passport_list.push(Passport.new) if row != "" && passport_list.length < passport_index + 1
        data = row.split(" ").map { |element| element.split(":") }
        data.each { |item| passport_list[passport_index].set_property item[0], item[1] }
    end

    # Count valid passports in passport_list
    valid_passports = passport_list.select { |passport| passport.valid? }
    p valid_passports
    p valid_passports.length

end

def upload file
    file = File.open(file)
    file_data = file.readlines.map(&:chomp)
    file.close
    file_data
end

count_valid_passports