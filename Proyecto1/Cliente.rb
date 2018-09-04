require 'socket'
require './Usuario'

class Cliente
  #  puts "Introdusca su IP: "
  #  host = gets.chop
  #  puts "Introdusca su Puerto:"
  #  port = gets.chop
  host="localhost"
  port="1234"

  puts "Introduzca su nombre de usuario: "
  name= gets.chop
  puts "Su usuario es #{name}\n"

s = TCPSocket.open(host, port) # host / puerto

  entradaMensajes=Thread.new{
    while msg= s.gets
      puts msg
    end
  }
  #Recibe los mensajes del usuario y los envia a el servidor

  while m=gets.chop do
    s.puts "#{name}: "+m
    if m=="/close"
      puts "Saliendo del servidor..."
      s.puts "#{name} desconectandose"
      entradaMensajes.kill
      s.close
      break
    end
  end
end
