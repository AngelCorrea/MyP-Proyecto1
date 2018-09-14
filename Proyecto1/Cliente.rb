require 'socket'
class Cliente

  host="localhost"
  port="1234"
  begin
    #puts "Introduzca su nombre de usuario: "
    #name= gets.chop
    s = TCPSocket.open(host, port) # host / puerto
    #s.puts name
    entradaMensajes=Thread.new{
      while msg= s.gets
        puts msg
      end
    }
    #Recibe los mensajes del usuario y los envia a el servidor

    while m=gets.chop do
      s.puts m
    end
  rescue Errno::EPIPE
    entradaMensajes.kill
    puts "Saliendo del servidor..."
    puts "#{name} desconectandose"
  end
end
