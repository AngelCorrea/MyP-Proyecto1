require "./Instrucciones.rb"
require "./Sala.rb"
class AccionesCliente
    @@rooms=[]

  def accionRoomMessage(comando,usuariosDiccionario,socketUsuario)
    orden=comando.split(" ",3)
    if(orden[1]==nil)
      socketUsuario.puts "Debes ingresar el nombre de una sala"
    elsif (!existeSala?(@@rooms,orden[1]))
      socketUsuario.puts "La sala no existe"
    else
      s=orden[1]
      diccion=buscaDiccionarioSala(@@rooms,s)
      accionPublicMessage("_ [#{s}]#{orden[2] }",diccion,socketUsuario)
    end
  end

  def existeSala?(salas,name)
    salas.each do |i|
      s=i.nombreSala
      if s ==name
        return true
      else
        next
      end
    end
    return false
  end

  def buscaDiccionarioSala(sala,nombre)
    sala.each do |i|
      if i.nombreSala == nombre
        return i.diccionarioSala
      else
        return nil
      end
    end
  end

  def accionIdentify(comando,usuariosDiccionario,socketUsuario)
    orden=comando.split(" ")
    username=orden[1]
    if(username==nil)
      socketUsuario.puts "Necesitas ingresar un nombre"
    elsif (!usuariosDiccionario[socketUsuario].equal?nil)
      socketUsuario.puts "Este usuario ya esta ocupado"
    else
      usuariosDiccionario[socketUsuario]=username
      socketUsuario.puts "Ahora esta identificado como #{username}"
      s="_ Se a conectado"
      accionPublicMessage(s,usuariosDiccionario,socketUsuario)
    end
  end

  def accionUsers(usuariosDiccionario,socketUsuario)
    s="Usuarios Identificados: \n"
    usuariosDiccionario.keys.each do |usuario|
      s=s+usuariosDiccionario[usuario]+"\n"
    end
    socketUsuario.puts s
  end

  def accionMessage(comando,usuariosDiccionario,socketUsuario,sala)
    orden=comando.split(" ")
    socketDestino=usuariosDiccionario.key orden[1]
    if(orden[1]==nil)
      socketUsuario.puts "Debes escribir el nombre del usuario a quien"+
      " quieras mandar el mensaje"
    elsif (orden[2]==nil)
      socketUsuario.puts "Debes escribir un mensaje"
    elsif (socketDestino.equal? nil)
      socketUsuario.puts "Este usuario no existe"
    else
      remitente=usuariosDiccionario[socketUsuario]
      mensaje=comando.split(" ",3)
      socketUsuario.puts "-[#{sala}]-#{remitente}: #{mensaje[2]}"
      socketDestino.puts "-[#{sala}]-#{remitente}: #{mensaje[2]}"
    end
  end

  def accionPublicMessage(comando,usuariosDiccionario,socketUsuario)
    mensaje=comando.split(" ",2)
    if (usuariosDiccionario[socketUsuario].equal? nil)
      socketUsuario.puts "Debes identificarte primero con \"IDENTIFY nombre\""
    elsif(mensaje[1]==nil)
      socketUsuario.puts "Debes ingresar un mensaje"
    else
      usuariosDiccionario.keys.each do |usr|
        usr.puts "#{usuariosDiccionario[socketUsuario]}: #{mensaje[1]}"
      end
    end
  end

  def accionCreateRoom(comando,usuariosDiccionario,socketUsuario)
    orden=comando.split(" ")
    if(orden[1]==nil)
      socketUsuario.puts "Debes ingresar un nombre para tu sala"
    elsif(existeSala?(@@rooms,orden[1]))
      socketUsuario.puts "El nombre de esta sala ya esta ocupado"
    else
      diccionarioSala=Hash.new
      username=usuariosDiccionario[socketUsuario]
      accionIdentify("_ [#{orden[1]}]#{username}",diccionarioSala,socketUsuario)
      salaNueva=Sala.new(orden[1],diccionarioSala)
      @@rooms.push salaNueva
      socketUsuario.puts "Has creado una sala: #{orden[1]}"
    end
  end


  def comandos(comando,usuariosDiccionario,socketUsuario)
    #begin
    orden=comando.split(" ")
    case orden[0]
    when "HELP"
      s=Instrucciones.new.instruccionesAyuda()
      socketUsuario.puts s
    when "IDENTIFY"
      accionIdentify(comando,usuariosDiccionario,socketUsuario)
      #PENDIENTE ____________________________
    when "STATUS"
      if(orden[1]==nil)
        socketUsuario.puts "Debe ingresar un estado ([ACTIVE][AWAY][BUSY])"
      end
    when "USERS"
      accionUsers(usuariosDiccionario,socketUsuario)
    when "MESSAGE"
      accionMessage(comando,usuariosDiccionario,socketUsuario,"Privado")
    when "PUBLICMESSAGE"
      accionPublicMessage(comando,usuariosDiccionario,socketUsuario)
    when "CREATEROOM"
      accionCreateRoom(comando,usuariosDiccionario,socketUsuario)
    when "INVITE"

    when "JOINROOM"

    when "ROOMESSAGE"
      accionRoomMessage(comando,usuariosDiccionario,socketUsuario)
    when "DISCONNECT"
      usuariosDiccionario.delete(socketUsuario)
      socketUsuario.close
    else
      socketUsuario.puts "Comando no identificado, use HELP para mostrar los comandos"
    end


  end
  #Fin de la clase

end
