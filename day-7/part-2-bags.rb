def number_of_inner_bags
    bags_data = upload("day-7/bag-data.txt")
    bags_data.map! { |bag| bag.tr(".", "").split(" contain ").map! { |b| b.split(",").map! { |el| el.split(" ") } } }
    outer_bags = create_outer_bags_hash bags_data
    bags_set = find_bags(outer_bags, "shiny-gold", 1, 0)
    p bags_set
end

def find_bags outer_bags, colour, other_bags, total
    outer_bags[colour].each do |bag|
        these_other_bags = bag[:count].to_i * other_bags
        total += these_other_bags
            total = find_bags(outer_bags, bag[:colour], these_other_bags, total)
        end
    total
end

def create_outer_bags_hash bags
    bags_hash = Hash.new {|h,k| h[k] = [] }
    bags.each do |bag|
        outer_bag_colour = "#{bag[0][0][0]}-#{bag[0][0][1]}"
        bag[1].each do |inner_bag|
            inner_bag_colour = inner_bag.length == 3 ? "#{inner_bag[0]}-#{inner_bag[1]}" : "#{inner_bag[1]}-#{inner_bag[2]}"
            inner_bag_count = inner_bag_colour == "no-other" ? 0 : inner_bag[0].to_i
            bags_hash[outer_bag_colour].push({colour: inner_bag_colour, count: inner_bag_count})
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

number_of_inner_bags