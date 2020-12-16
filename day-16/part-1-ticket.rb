require_relative '../helper'
include Helper

ticket_data = Helper::upload("day-16/ticket-data.txt")
test_data = [
    "class: 1-3 or 5-7",
    "row: 6-11 or 33-44",
    "seat: 13-40 or 45-50",
    "",
    "your ticket:",
    "7,1,14",
    "",
    "nearby tickets:",
    "7,3,47",
    "40,4,50",
    "55,2,20",
    "38,6,12",
]

def process_tickets(data)
    constraints = {}
    constraints_count = 0
    error_rate = 0
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
            constraints[constraints_count] = [
                (field_constraints[0][0]..field_constraints[0][1]),
                (field_constraints[1][0]..field_constraints[1][1])
            ]
            constraints_count += 1
        when "nearby_tickets"
            if field[0] != "nearby tickets"
                ticket_fields = field[0].split(",").map(&:to_i)
                ticket_fields.each do |num|

                    outside_constraint = true
                    (0...constraints_count).each do |index|
                        if constraints[index][0].include?(num) || constraints[index][1].include?(num)
                            outside_constraint = false 
                            break
                        end
                    end
                    error_rate += num if outside_constraint
                end
            end
        end
    end
    p error_rate
end

process_tickets(ticket_data)