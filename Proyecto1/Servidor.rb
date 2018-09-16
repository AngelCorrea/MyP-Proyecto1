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
        conecct.puts "Bienvenido al servidor :D\n Use \"HELP\" para ver los comandos del servidor"
        comunicacionChat(conecct)
      end
    }.join
  end


  def comunicacionChat(socketUsuario)
    begin
      loop do
        entrada=socketUsuario.gets
        s=Acciones.new.comandos(entrada,@clientes,socketUsuario)
      end
    rescue Errno::EPIPE
      @clientes.delete(usuario)
      puts " Usuario desconectado "
      puts @clientes.to_s + "Usuarios actuales"
      @hilo.exit
      socketUsuario.close
    end
  end
#Fin de la clase
end

Servidor.new("1234")
