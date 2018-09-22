require 'socket'
require "./Acciones.rb"
class Servidor
  #Clase servidor

  #Constructor de la clase
  #Recibe el puerto con el que crearemos un socket
  #Creamos un arreglo que sera nuestra lista de clientes conectados
  #Mandamos un mensaje del servidor iniciandose.
  def initialize (puerto)
    @socketPrincipal=TCPServer.open(puerto)

    @clientes =[]

    puts "Servidor iniciandose..."
    startServer()
  end

  #Metodo para iniciar el servidor.
  #El servidor estara en un ciclo, y para cada usuario que se conecte, se creara
  #un hilo nuevo, se les enviara un mensaje de bienvenida y llamaremos al
  #metodo "comunicacionChat" para la entrada de mensajes del usuario
  def startServer
    loop {
      sesion = @socketPrincipal.accept
      @hilo=Thread.start (sesion) do |conecct|
        conecct.puts "Bienvenido al servidor :D\nUse \"HELP\" para ver los comandos del servidor"
        comunicacionChat(conecct)
      end
    }.join
  end

  #Metodo para la comunicacion del cliente con el servidor
  #Recibimos el socket del usuario
  #Mientras haya entrada del socket, mandamos la cadena a el metodo "comandos"
  #de la clase Acciones para que el mensaje se a filtrado, y regrese una accion
  #en caso de que sea necesario. Si la conexion llega a romperse, cachamos la
  #excepcion y llamamos al metodo, accionDisconnect para desconectar
  #correctamente al usuario.

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
#Objeto para ejecutar el servidor.
Servidor.new("1234")
