require 'socket'
require './AccionesCliente.rb'
class Servidor

  def initialize (puerto)
    @socketPrincipal=TCPServer.open(puerto)

    @clientes =Hash.new

    puts "Servidor iniciandose..."
    startServer()
  end

  def startServer
    loop {
      sesion = @socketPrincipal.accept
      @hilo=Thread.start (sesion) do |conecct|
        conecct.puts "Bienvenido al servidor :D"
        comunicacionChat(conecct)
      end
    }.join
  end


  def comunicacionChat(socketUsuario)
  #def comunicacionChat(usuario, socketUsuario)
    begin
      loop do
        entrada=socketUsuario.gets
        s=AccionesCliente.new.comandos(entrada,@clientes,socketUsuario)
        #socketUsuario.puts s
        #if entrada=="/close"
        #  break
        #end
        #puts @clientes
        #@clientes.keys.each do |usr|
          #@clientes[usr].puts "#{usuario}: #{entrada}"
        #end
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
