require 'set'
require_relative '../helper'
include Helper

test_data = Helper::upload("2020/day-21/test-data.txt")
food_data = Helper::upload("2020/day-21/food-data.txt")

def find_food_without_allergens data
    foods = []
    ingredients = Set.new
    ingredient_count = Hash.new(0)
    allergen_set = Set.new
    allergens = []
    
    food_data = data.map do |food|
        food_cleaned = food.split(" (contains ")
        food_cleaned[0] = food_cleaned[0].split(" ").to_set
        food_cleaned[1] = food_cleaned[1].tr(')', '').split(", ")
        foods.push({ "ingredients" => food_cleaned[0], "allergens" => food_cleaned[1] })
        ingredients.merge(food_cleaned[0])
        food_cleaned[0].each { |ingredient| ingredient_count[ingredient] += 1 }
        food_cleaned[1].each do |allergen|
            if !allergen_set.include?(allergen)
                allergens.push({"name" => allergen, "ingredient" => nil, "found" => false})
            end
        end
        allergen_set.merge(food_cleaned[1])
    end
    all_indentified = true
    loop do
        not_changed = true
        allergens.map do |allergen|
            if !allergen["found"]
                possible_ingredients = Marshal.load(Marshal.dump(ingredients))
                foods.each do |food|
                    possible_ingredients = food["ingredients"] & possible_ingredients if food["allergens"].include?(allergen["name"])
                end
                allergen["ingredient"] = possible_ingredients
                if possible_ingredients.length == 1
                    allergen["found"] = true
                    not_changed = false
                    ingredients  = ingredients - possible_ingredients
                end
            end
            all_indentified = allergen["found"] && all_indentified
        end
        break if all_indentified || not_changed
    end

    dangerous_ingredients = ""
    sorted_allergens = allergen_set.to_a.sort
    allergens_hash = {}
    allergens.each { |allergen| allergens_hash[allergen["name"]] = allergen["ingredient"].to_a[0] + ","  }
    sorted_allergens.each { |allergen| dangerous_ingredients += allergens_hash[allergen] }

end

find_food_without_allergens(food_data)