#Se llama el recurso "socket"
require 'socket'
#Socket abierto para escuchar en el puerto "1234"
class Servidor
  puts "Introdusca su IP: "
  host = gets.chop
  puts "Introdusca su Puerto:"
  port = gets.chop

  puts "Servidor iniciandose... "
  server = TCPServer.open(host,port)
  while(sesion=server.accept)
    #El servidor acepta a los que intenten conectarse
    Thread.start do
      puts "Conectado desde #{sesion.peeraddr[2]} en #{sesion.peeraddr[3]}"
      sesion.puts "Server : Bienvenido #{sesion.peeraddr[2]}\n"
      sesion.puts "Escriba una entrada"
      entrada=sesion.gets
      puts "cliente: #{entrada}"

      puts "Enviando adios"
      sesion.puts "Server: Adios\n"

    end
  end
end
