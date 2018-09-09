require 'socket'
require './Auxiliares.rb'
class Servidor

  def initialize (puerto)
    @socketPrincipal=TCPServer.open(puerto)

    @clientes =Hash.new

    puts "Servidor iniciandose..."
    startServer()
  end

  def startServer
    #Este loop se ejecutara hasta que una orden interna
    #le ordene parar.
    loop {
      #Aceptamos a todos los clientes que se quieran
      #conectar con elk socket
      sesion = @socketPrincipal.accept
      #Para los usuarios que se quieran conectar, realizamos
      #las siguientes acciones(conecct).
      @hilo=Thread.start (sesion) do |conecct|
        #La primera cadena que entre del cliente al servidor
        #sera su identificador (Nombre de Usuario)
        userName=conecct.gets.chomp.to_sym
        #Convertimos la cadena a un "simbolo", para ocuparlo
        #elemento en el diccionario de clientes.
        #userName => :userName

        #Verificamos si el nombre que recibimos esta en el
        #diccionario "@conexiones[:clientes]"
        if(@clientes[userName]!=nil)
          #Si ya existe este, expulsamos al cliente cerrando todos sus
          #antes de que salga.
          conecct.puts "Este nombre de usuario ya esta ocupado"
          conecct.puts "Saliendo"
          conecct.close
          @hilo.kill
        end
        #Si el nombre de Usuario esta libre, lo agregamos al
        #diccionario como un usuario en la seccion de clientes
        #y asociamos a su nombre con su socket correspondiente
        @clientes[userName]=conecct
        puts
        puts "Un usuario #{userName} se ha conectado desde: -> #{conecct}"
        #Notificamos al cliente que se a conectado
        conecct.puts "Su usuario es #{userName}, esta conectado desde #{conecct}
        y ahora puede comunicarse"
        #Invocamos este metodo para establecer comunicacion entre los clientes
        comunicacionChat(userName,conecct)
      end
    }.join
  end

  def comunicacionChat(usuario, socketUsuario)
    begin
      loop do
        entrada=socketUsuario.gets
        if entrada=="/close"
          break
        end
        puts @clientes
        @clientes.keys.each do |usr|
          @clientes[usr].puts "#{usuario}: #{entrada}"
        end
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
