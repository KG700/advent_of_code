require_relative '../helper'
include Helper

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
            @byr = value if valid_birth_year? value
        when "iyr"
            @iyr = value if valid_issue_year? value
        when "eyr"
            @eyr = value if valid_expiration_year? value
        when "hgt"
            @hgt = value if valid_height? value
        when "hcl"
            @hcl = value if valid_hair_colour? value
        when "ecl"
            @ecl = value if valid_eye_colour? value
        when "pid"
            @pid = value if valid_passport_id? value
        when "cid"
            @cid = value
        end
    end

    def valid_birth_year? value
        value.to_i >= 1920 && value.to_i <= 2002
    end

    def valid_issue_year? value
        value.to_i >= 2010 && value.to_i <= 2020
    end

    def valid_expiration_year? value
        value.to_i >= 2020 && value.to_i <= 2030
    end

    def valid_height? value
        height_value = value[0, value.length - 2].to_i
        height_metric = value[value.length - 2, value.length]
        is_integer = height_value.is_a?(Integer) 
        is_correct_metric = (height_metric == "cm" || height_metric == "in")
        is_in_range = false
        if is_correct_metric
            is_in_range = height_value >= 150 && height_value <= 193 if height_metric == "cm"
            is_in_range = height_value >= 59 && height_value <= 76 if height_metric == "in"
        end
        is_integer && is_correct_metric && is_in_range
    end

    def valid_hair_colour? value
        !!value[/^#[0-9a-f]{6}/] && value.length == 7
    end

    def valid_eye_colour? value
        possible_eye_colours = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
        possible_eye_colours.include? value
    end

    def valid_passport_id? value
        value.to_i.is_a?(Integer) && value.length == 9
    end

    def valid?
        !(@byr.nil? || @iyr.nil? || @eyr.nil? || @hgt.nil? || @hcl.nil? || @ecl.nil? || @pid.nil?)
    end

end

def count_valid_passports
    passport_data = Helper::upload("2020/day-04/passport_data.txt")

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
    p valid_passports.length

end

count_valid_passports