require 'set'
require_relative '../helper'
include Helper

data = Helper::upload("2022/day-16/input.txt")
data_test = Helper::upload("2022/day-16/input-test.txt")

class Valve

    attr_reader :tunnel_labels, :label, :flow_rate, :tunnels, :valves

    def initialize label, flow_rate, tunnels
        @label = label
        @flow_rate = flow_rate
        @tunnel_labels = tunnels
        @valves = {} # {label: "AA", minutes: 1, flow_rate_per_minute: 3}
    end

    def set_valves valves_map
        valves_added = Set.new([@label])
        
        i = 1
        valves_to_check = Helper::deep_copy(@tunnel_labels)
        loop do
            valves_to_check_next = []
            valves_to_check.each do |valve_label|
                unless valves_added.include?(valve_label)
                    @valves[valve_label] = {minutes: i, flow_rate: valves_map[valve_label].flow_rate, pressure: nil}
                    valves_added.add(valve_label)
                end
            end
            valves_to_check.each do |valve_label|
                valves_map[valve_label].tunnel_labels.each do |tunnel_label|
                    unless valves_added.include?(tunnel_label)
                        valves_to_check_next.push(tunnel_label)
                    end
                end
            end
            i += 1
            break if valves_to_check_next.length == 0
            valves_to_check = Helper::deep_copy(valves_to_check_next)
        end
    end

    def maximum_pressure time_left, valves_left, valves_map
        return [{total: 0}] if time_left <= 0
        return [{total: 0}] if valves_left.length == 0

        pressure_map_array = []
        pressure_map_array_1 = []
        valves_left.each do |valve_label|

            if @valves[valve_label][:minutes] + 1 < time_left
                remaining_valves = Helper::deep_copy(valves_left)
                remaining_valves.delete(valve_label)
                updated_time_left = time_left - (@valves[valve_label][:minutes] + 1)
                pressure = valves_map[valve_label].flow_rate * updated_time_left
                pressure_map_array_1 = valves_map[valve_label].maximum_pressure(updated_time_left, remaining_valves, valves_map)
                pressure_map_array_1 = pressure_map_array_1.map do |pressure_map| 
                    pressure_map[valve_label] = pressure
                    pressure_map[:total] += pressure
                    pressure_map
                end
                
            else
                pressure_map_array_1 = [{total: 0}]
            end
            pressure_map_array_1.each { |pressure_map| pressure_map_array.push(pressure_map) }
        end

        pressure_map_array

    end

end

MINUTES = 30

def calculate data

    valves = {}
    visited_valves = Set.new

    data.each do |line|
        label, flow_rate =  line.scan(/Valve (.*) has flow rate=(.*);/).first
        tunnels = line.split(";")[1].gsub(" tunnel leads to valve ", "").gsub(" tunnels lead to valves ", "")
        valves[label] = Valve.new(label, flow_rate.to_i, tunnels.split(", "))
    end

    valves_to_open = valves.select { |label, valve| valve.flow_rate > 0 }.values.map { |valve| valve.label }
    valves.values.each { |valve| valve.set_valves(valves) }

    time_left = MINUTES
    room = valves["AA"]
    pressure = room.maximum_pressure(time_left, valves_to_open, valves)

    p "-----"
    max_pressure = 0
    pressure.each { |valve| max_pressure = max_pressure > valve[:total] ? max_pressure : valve[:total] }
    max_pressure_from_valves = pressure.select { |valve| valve[:total] == max_pressure }

    p max_pressure_from_valves.first

end

calculate data