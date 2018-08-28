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
#while mensajesServer=s.gets
#    puts mensajesServer
#  end


#Recibe los mensajes del usuario y los envia a el servidor
  begin
    while m=gets.chop and m!="/close"
      s.puts "#{name}: "+m
    end
puts "Saliendo del servidor..."
s.puts "Cliente desconectandose"
s.close
end

end
