#Se llama el recurso "socket"
require 'socket'
require './Auxiliares.rb'
#Socket abierto para escuchar en el puerto "1234"
class Servidor
  port =1234
  puts "Servidor iniciandose... "

  server = TCPServer.open(port)
  usuarios=[]
  #Thread para cada conexion
  #El servidor acepta a los que intenten conectarse

    while(sesion=server.accept)
      usuarios.push(sesion)
      hilo=Thread.start sesion do |conecct|
        while entrada=conecct.gets and entrada!="/close"
          puts usuarios.length
          puts "cliente: #{entrada}"
          usuarios.each do |i|
            i.puts "#{entrada}"
            puts i
          end
        end
        usuarios=Auxiliares.new.busquedaArreglo(conecct,usuarios)
        hilo.kill
        puts "Un usario a salido"
        conecct.close
        #-------Salida del while-------------
      end
    end


end
