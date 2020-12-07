require "set"

def number_of_outer_bags
    bags_data = upload("day-7/bag-data.txt")
    bags_data.map! { |bag| bag.tr(".", "").split(" contain ").map! { |b| b.split(",").map! { |el| el.split(" ") } } }
    inner_bags = create_inner_bags_hash bags_data
    bags_set = find_bags(inner_bags, "shiny-gold", Set.new())
    p bags_set.length
end

def find_bags inner_bags, colour, set
    if colour != "no-other"
        inner_bags[colour].each do |col| 
            set.add(col)
            find_bags(inner_bags, col, set) 
        end
    end
    set
end

def create_inner_bags_hash bags
    bags_hash = Hash.new {|h,k| h[k] = [] }
    bags.each do |bag|
        outer_bag_colour = "#{bag[0][0][0]}-#{bag[0][0][1]}"
        bag[1].each do |inner_bag|
            inner_bag_colour = inner_bag.length == 3 ? "#{inner_bag[0]}-#{inner_bag[1]}" : "#{inner_bag[1]}-#{inner_bag[2]}"
            bags_hash[inner_bag_colour].push(outer_bag_colour)
        end
    end
    bags_hash
end

def upload file
    file = File.open(file)
    file_data = file.readlines.map(&:chomp)
    file.close
    file_data
end

number_of_outer_bags