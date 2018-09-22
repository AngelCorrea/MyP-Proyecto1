require 'socket'

#Clase cliente
class Cliente
  #Constructor del cliente, recibe una variable del tipo Socket
  def initialize(socket)
  @@socket = socket # host / puerto
  end

  #Metodo para enviar mensajes al servidor
  def enviarMensaje(mensaje)
    @@socket.puts mensaje
  end
  #Metodo para recibir mensajes del servidor
  def entrada()
    return @@socket.gets
  end
  #Fin de la clase
end
