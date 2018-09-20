require 'socket'
class Cliente
  @ip="localhost"
  @port="1234"
  @@socket = TCPSocket.open(@host, @port) # host / puerto
  def enviarMensaje(mensaje)
    @@socket.puts mensaje
  end

  def entrada()
    return @@socket.gets
  end
end
