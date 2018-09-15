require "./Instrucciones.rb"
require "./Sala.rb"
require "./Usuario.rb"
class Acciones
  @@rooms=[] #Arreglo para salas (nombreSala,usuariosLista)

  def accionIdentify(comando,usuariosLista,socketUsuario)
    orden=comando.split(" ")
    username=orden[1]
    usr=buscaUsuarioPorSocket(usuariosLista,socketUsuario)
    if(username==nil)
      socketUsuario.puts "Necesitas ingresar un nombre"
    elsif (nombreExiste?(username,usuariosLista))
      socketUsuario.puts "Este usuario ya esta ocupado"
    else
      status="ACTIVE"
      usuario=Usuario.new(username,socketUsuario,status)
      usuariosLista.push(usuario)
      socketUsuario.puts "Ahora esta identificado como #{username}"
      s="_ Se a conectado"
      accionPublicMessage(s,usuariosLista,socketUsuario)
    end
  end

  def accionStatus(comando,usuariosLista,socketUsuario)
    orden=comando.split(" ")
    status=orden[1]
    usr=buscaUsuarioPorSocket(usuariosLista,socketUsuario)
    if(usr == nil)
      return "Debe identificarse primero con IDENTIFY -Username-"
    elsif(status==nil)
      socketUsuario.puts "Debe ingresar un estado (ACTIVE,AWAY,BUSY)"
    elsif(status!="ACTIVE" and status!="AWAY" and status!="BUSY")
      socketUsuario.puts "Estado no valido"
      socketUsuario.puts "Debe ingresar un estado (ACTIVE,AWAY,BUSY)"
    elsif (status == usr.status)
      socketUsuario.puts "Su estado actual es ese"
    else
      usr.setStatus(status)
      socketUsuario.puts "Su estado a cambiado a #{usr.status}"
    end
  end


  def buscaUsuarioPorSocket(arreglo,socketUsuario)
    arreglo.each do |usr|
      if(usr.socket.equal? socketUsuario)
        return usr
      else
        next
      end
    end
    return nil
  end

  def buscaUsuarioPorNombre(arreglo,nombre)
    arreglo.each do |usr|
      if(usr.name== nombre)
        return usr
      else
        next
      end
    end
    return nil
  end
  def existeSala?(nombre)
    for i in @@rooms
      if i.name == nombre
        return true
      else
        next
      end
    end
    return false
  end
  def nombreExiste? (nombre,usuariosLista)
    for i in usuariosLista
      if(i.name == nombre)
        return true
      else
        next
      end
    end
    return false
  end

  def accionUsers(usuariosLista,socketUsuario)
    s="Usuarios Identificados: \n"
    for i in usuariosLista
      s=s+i.name+"\n"
    end
    socketUsuario.puts s
  end


  def accionMessage(comando,usuariosLista,socketUsuario)
    orden=comando.split(" ")
    nombreDestino=orden[1]
    usr=buscaUsuarioPorSocket(usuariosLista,socketUsuario)
    usrDestino=buscaUsuarioPorNombre(usuariosLista,nombreDestino)
    if(usr == nil)
      return "Debe identificarse primero con IDENTIFY -Username-"
    elsif (nombreDestino==nil)
      socketUsuario.puts "Debes escribir el nombre del usuario a quien"+
      " quieras mandar el mensaje"
    elsif (orden[2]==nil)
      socketUsuario.puts "Debes escribir un mensaje"
    elsif (usrDestino==nil)
      socketUsuario.puts "Este usuario no existe"
    else
      mensaje=comando.split(" ",3)
      usr.socket.puts "-[Privado]-(#{usr.status})#{usr.name}: #{mensaje[2]}"
      usrDestino.socket.puts "-[Privado]-(#{usr.status})#{usr.name}: #{mensaje[2]}"
    end
  end

  def accionPublicMessage(comando,usuariosLista,socketUsuario)
    mensaje=comando.split(" ",2)
    usr=buscaUsuarioPorSocket(usuariosLista,socketUsuario)
    if (usr.equal? nil)
      socketUsuario.puts "Debes identificarte primero con \"IDENTIFY nombre\""
    elsif(mensaje[1]==nil)
      socketUsuario.puts "Debes ingresar un mensaje"
    else
      for cliente in usuariosLista
        cliente.socket.puts "[#{usr.status}] #{usr.name}: #{mensaje[1]}"
      end
    end
  end

  def accionCreateRoom(comando,usuariosLista,socketUsuario)
    orden=comando.split(" ")
    usr=buscaUsuarioPorSocket(usuariosLista,socketUsuario)
    if (usr.equal? nil)
      socketUsuario.puts "Debes identificarte primero con \"IDENTIFY nombre\""
    elsif(orden[1]==nil)
      socketUsuario.puts "Debes ingresar un nombre para tu sala"
    elsif(existeSala?(orden[1]))
      socketUsuario.puts "El nombre de esta sala ya esta ocupado"
    else
      listaSala=[]
      accionIdentify("_ [#{orden[1]}]#{usr.name}",listaSala,socketUsuario)
      salaNueva=Sala.new(orden[1],listaSala)
      @@rooms.push salaNueva
      socketUsuario.puts "Has creado una sala: #{orden[1]}"
    end
  end

  def comandos(comando,usuariosLista,socketUsuario)
    #begin
    orden=comando.split(" ")
    case orden[0]
    when "HELP"
      s=Instrucciones.new.instruccionesAyuda()
      socketUsuario.puts s
    when "IDENTIFY"
      accionIdentify(comando,usuariosLista,socketUsuario)
    when "STATUS"
      accionStatus(comando,usuariosLista,socketUsuario)
    when "USERS"
      accionUsers(usuariosLista,socketUsuario)
    when "MESSAGE"
      accionMessage(comando,usuariosLista,socketUsuario)
    when "PUBLICMESSAGE"
      accionPublicMessage(comando,usuariosLista,socketUsuario)
    when "CREATEROOM"
      accionCreateRoom(comando,usuariosLista,socketUsuario)
    when "INVITE"

    when "JOINROOM"

    when "ROOMESSAGE"
      accionRoomMessage(comando,usuariosLista,socketUsuario)
    when "DISCONNECT"
      usuariosLista.delete(socketUsuario)
      socketUsuario.close
    else
      socketUsuario.puts "Comando no identificado, use HELP para mostrar los comandos"
    end
  end
end
