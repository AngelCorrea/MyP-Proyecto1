#Se llama el recurso "socket"
require 'socket'
#Socket abierto para escuchar en el puerto "1234"
class Servidor
  host="localhost"
  port="1234"
  server = TCPServer.open(host,port)
  puts "Servidor iniciandose... "

  #El servidor acepta a los que intenten conectarse

  loop {
    conexionCliente=server.accept
    Thread.start(conexionCliente) do |conectado|
      conectado.puts("Bienvenido al Oceano")
      conectado.puts("Hoy es "+Time.now.ctime)
      conectado.puts "Escribe un mensaje"
      conectado.close
      end
    }
end
