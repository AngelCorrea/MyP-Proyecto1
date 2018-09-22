class Sala
  #Clase Sala

  #Constructor de la sala.
  #-nombreSala- Tipo String: Es el nombre de la sala
  #-listaSala- Tipo Arreglo: Arreglo de usuarios en la sala
  def initialize(nombreSala,listaSala)
    @nombreSala=nombreSala
    @listaSala=listaSala
  end
  #Metodo que devuelve el nombre de la sala.
  def name
    return @nombreSala
  end
  #Metodo que devuelve la lista de usuarios de la sala.
  def lista
    return @listaSala
  end
end
