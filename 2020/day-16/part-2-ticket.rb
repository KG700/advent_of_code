require_relative '../helper'
include Helper

ticket_data = Helper::upload("2020/day-16/ticket-data.txt")
test_data = [
    "class: 0-1 or 4-19",
    "row: 0-5 or 8-19",
    "seat: 0-13 or 16-19",
    "",
    "your ticket:",
    "11,12,13",
    "",
    "nearby tickets:",
    "3,9,18",
    "1,20,16",
    "15,1,5",
    "5,14,9"
]

def process_tickets(data)
    constraints = {}
    constraints_count = 0
    nearby_tickets = []
    my_ticket = []
    row_type = nil
    data.each do |field|
        field = field.split(":")
       row_type = "empty" if field.empty?
        row_type = "constraints" if field.length == 2
        row_type = "my_ticket" if field[0] == "your ticket"
        row_type = "nearby_tickets" if field[0] == "nearby tickets"

        case row_type
        when "constraints"
            field_constraints = field[1].split(" or ").map { |con| con.split("-").map(&:to_i) }
            constraints[constraints_count] = { 
                "name" => field[0],
                "cons" => [
                (field_constraints[0][0]..field_constraints[0][1]),
                (field_constraints[1][0]..field_constraints[1][1])
                ],
                "order" => [],
                "confirmed" => false,
                "me" => nil
        }
            constraints_count += 1
        
        when "my_ticket"
            if field[0] != "your tickets"
                my_ticket = field[0].split(",").map(&:to_i)
            end 
        
        when "nearby_tickets"
            if field[0] != "nearby tickets"
                ticket = field[0].split(",").map(&:to_i)
                nearby_tickets.push(ticket) if validate_ticket(ticket, constraints)
            end
        end
    end

    values_per_field = Hash.new {|h,k| h[k]=[]}
    nearby_tickets.each do |ticket|
        ticket.each_with_index do |field, index|
            values_per_field[index].push(field)
        end
    end

    constraints.each do |cons_id, cons|
        values_per_field.each do |val_id, values|
            meets_constraints = true
            values.each do |value|
                if !cons["cons"][0].include?(value) && !cons["cons"][1].include?(value)
                    meets_constraints = false
                end
            end
            if meets_constraints
                cons["order"].push(val_id)
            end
        end
    end

    loop do
        constraints.each do |id, val|
            if val["order"].length == 1
                constraints = clean_constraints(constraints, id, val["order"][0])
            end
        end
        break if all_confirmed?(constraints)
    end

    constraints.each do |key, value|
        constraints[key]["me"] = my_ticket[value["order"][0]]
    end

    mult = 1
    constraints.each { |key, value| mult *= value["me"] if value["name"].include?("departure") }
    p mult

end

def validate_ticket ticket, constraints
    ticket_valid = true
    ticket.each do |num|
        valid = false
        constraints.each do |key, value|
            if value["cons"][0].include?(num) || value["cons"][1].include?(num)
                valid = true
                break
            end
        end
        ticket_valid = valid && ticket_valid
    end
    return ticket_valid
end

def clean_constraints constraints, field_id, value
    constraints.each do |key, val|

        constraints[key]["order"].delete(value) if key != field_id
    end
    constraints[field_id]["confirmed"] = true
    constraints
end

def all_confirmed? constraints
    all_confirmed = true
    constraints.each do |id, constraint|
        if !constraint["confirmed"]
            all_confirmed = false
            break
        end
    end
    all_confirmed
end

process_tickets(ticket_data)