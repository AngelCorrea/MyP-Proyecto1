class Usuario
  #Clase usuario

  #Constructor de usuario
  #Recibe un nombre(string), un socket(socket) y un status(string)
  def initialize(name,socket,status)
    @name=name
    @socket=socket
    @status=status
  end

  #Metodo que devuelve el nombre del objeto usuario.
  def name
    return @name
  end
  #Metodo que devuelve el socket del objeto usuario.
  def socket
    return @socket
  end
  #Metodo que deuvuelve el estado del objeto usuario.
  def status
    return @status
  end
  #Metodo que establece el estado del objeto usuario.
  def setStatus(nuevoStatus)
    @status=nuevoStatus
  end
  #Fin de la clase
end
