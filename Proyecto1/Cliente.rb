require 'socket'
class Cliente
#10.42.0.46
  host="10.42.0.86"#"localhost"
  port="1234"
  begin

    s = TCPSocket.open(host, port) # host / puerto
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
  end
end
