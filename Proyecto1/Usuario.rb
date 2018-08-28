class Usuario
  attr_accessor :nombre

  #def initialize(nombre)
  #  self.nombre=nombre
  #end
  def setNombre(nombre)
    self.nombre=nombre
  end
  def getNombre()
    return nombre
  end

end
