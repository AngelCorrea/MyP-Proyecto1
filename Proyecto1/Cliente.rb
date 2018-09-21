require 'socket'
class Cliente

  def initialize(socket)
  @@socket = socket # host / puerto  
  end


  def enviarMensaje(mensaje)
    @@socket.puts mensaje
  end

  def entrada()
    return @@socket.gets
  end
end
