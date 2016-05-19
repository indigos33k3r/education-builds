#! /usr/bin/env ruby

require 'json'
require 'csv'
require 'yaml'


if ARGV.empty?
  puts "Usage: enrollment_parser enrollment.csv"
  exit 1
end


output = {"students" => {}}

students = CSV.new(File.read(ARGV[0]), :headers => true, :header_converters => :symbol).to_a.map {|row| row.to_hash } 

students.each do |student|
  output["students"][student[:contactdisplayname]] = student[:contactemail]
end


puts "Select course from the list below"
puts "---------------------------------"

courses_hash = YAML.load(File.read('./codes.yaml'))

courses_hash.keys.each_with_index do  |course_name, index|
  puts (index + 1).to_s + ": " + course_name
end

puts "---------------------------------"
printf "Course number: "
coursenum = $stdin.gets.chomp.to_i
if coursenum > courses_hash.keys.length
  puts "Error: Invalid selection"
  exit 1
else
  coursenum = coursenum - 1
  puts courses_hash.keys[coursenum]
  output["title"] = courses_hash[courses_hash.keys[coursenum]]
end


puts
printf "Course ID: "
output["course_id"] = $stdin.gets.chomp
printf "Description: "
output["description"] = $stdin.gets.chomp
printf "Start Date: "
output["start"] = $stdin.gets.chomp
printf "End Date: "
output["end"] = $stdin.gets.chomp
printf "Instructor Name: "
instructor = $stdin.gets.chomp
printf "Instructor Email: "
output["students"][instructor] = $stdin.gets.chomp

puts JSON.generate(output)
