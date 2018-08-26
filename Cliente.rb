require 'socket'
require './Usuario'
class Cliente
  puts "Introdusca su IP: "
  host = gets.chop
  puts "Introdusca su Puerto:"
  port = gets.chop

  s = TCPSocket.open(host, port) # host / puerto


puts "Introdusca su nombre de usuario: "
name= gets.chop
usr1=Usuario.new
usr1.setNombre("name")
puts "Su usuario es #{name}\n"

s.puts name


  begin
    line= s.gets
    puts line
    line= s.gets
    puts line
  m=gets
  s.puts m
  line= s.gets
  puts line
  s.puts "Cliente desconectandose"
s.close
end

end
