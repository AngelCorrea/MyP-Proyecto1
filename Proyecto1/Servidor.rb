require 'socket'
#require './AccionesCliente.rb'
require "./Acciones.rb"
class Servidor

  def initialize (puerto)
    @socketPrincipal=TCPServer.open(puerto)

    @clientes =[]

    puts "Servidor iniciandose..."
    startServer()
  end

  def startServer
    loop {
      sesion = @socketPrincipal.accept
      @hilo=Thread.start (sesion) do |conecct|
        conecct.puts "Bienvenido al servidor :D\nUse \"HELP\" para ver los comandos del servidor"
        comunicacionChat(conecct)
      end
    }.join
  end


  def comunicacionChat(socketUsuario)
    socket=socketUsuario
    begin
      while entrada=socketUsuario.gets
        s=Acciones.new.comandos(entrada,@clientes,socketUsuario)
      end
      puts " Usuario desconectado "
      Acciones.new.accionDisconnect(@clientes,socket)
      @hilo.exit
      socketUsuario.close
    rescue Errno::EPIPE
      puts " Usuario desconectado "
      Acciones.new.accionDisconnect(@clientes,socket)
      @hilo.exit
      socketUsuario.close
    end
  end
#Fin de la clase
end

Servidor.new("1234")
