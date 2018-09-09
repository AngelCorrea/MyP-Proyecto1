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
  s = TCPSocket.open(host, port) # host / puerto
  s.puts name
  entradaMensajes=Thread.new{
    while msg= s.gets
      puts msg
    end
  }
  #Recibe los mensajes del usuario y los envia a el servidor

  while m=gets.chop do
    s.puts m
    if m=="/close"
      puts "Saliendo del servidor..."
      s.puts "#{name} desconectandose"
      entradaMensajes.kill
      s.close
      break
    end
  end
end
