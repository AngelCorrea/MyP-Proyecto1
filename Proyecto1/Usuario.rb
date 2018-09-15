class Usuario
  def initialize(name,socket,status)
    @name=name
    @socket=socket
    @status=status
  end

  def name
    return @name
  end
  def socket
    return @socket
  end
  def status
    return @status
  end
  def setStatus(nuevoStatus)
    @status=nuevoStatus
  end
end
