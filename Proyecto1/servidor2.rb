#Se llama el recurso "socket"
require 'socket'
#Socket abierto para escuchar en el puerto "1234"
class Servidor
  puts "Introduzca su IP: "
  host = gets.chop
  puts "Introduzca su Puerto:"
  port = gets.chop

  puts "Servidor iniciandose... "
  server = TCPServer.open(host,port)
  while(sesion=server.accept)
    #El servidor acepta a los que intenten conectarse
    Thread.start do
    puts "Conectado desde #{sesion.peeraddr[2]} en #{sesion.peeraddr[3]}"
    sesion.puts "Server : Bienvenido, su ip es #{sesion.peeraddr[2]}\n"
    sesion.puts "Comience a escribir"
    end
    Thread.start do
      while entrada=sesion.gets
        sesion.puts entrada
      puts "cliente: #{entrada}"
    end

      puts "Enviando adios"
      sesion.puts "Server: Adios\n"
      sesion.stop
    end
  end
end
