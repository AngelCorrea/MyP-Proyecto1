class Auxiliares

  def busquedaArreglo(elemento,arreglo)
    i=0
    while(i<arreglo.length)
      if(arreglo[i].equal? elemento)
        arreglo.delete(i)
        return arreglo
      else
        i+=1
      end
    end
  end
end
