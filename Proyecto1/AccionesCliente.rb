require "./Instrucciones.rb"
class AccionesCliente

  def comandos(comando,usuariosDiccionario,socketUsuario)
    #begin
    orden=comando.split(" ")
    case orden[0]

    when "HELP"
      s=Instrucciones.new.instruccionesAyuda()
      socketUsuario.puts s
    when "IDENTIFY"
      username=orden[1]
      if(username==nil)
        puts socketUsuario.puts "Necesitas ingresar un nombre"
      elsif (usuariosDiccionario[socketUsuario]!=nil)
        socketUsuario.puts "Este usuario ya esta ocupado"
      else
        usuariosDiccionario[socketUsuario]=username
        socketUsuario.puts "Ahora esta identificado como #{username}"
      end

    when "STATUS"
      #  if(orden[1]==nil)

    when "USERS"
      s="Usuarios Identificados: "
      usuariosDiccionario.keys.each do |usuario|
        s=s+usuariosDiccionario[usuario]+"\n"
      end
      socketUsuario.puts s

    when "MESSAGE"
      if(orden[1]==nil)
        socketUsuario.puts "Debes escribir el nombre del usuario a quien"+
        " quieras mandar el mensaje"
      elsif (orden[2]==nil)
        socketUsuario.puts "Debes escribir un mensaje"
      end
      #
      socketDestino=usuariosDiccionario.key orden[1]

      if (socketDestino.equal? nil)
        socketUsuario.puts "Este usuario no existe"
      else
        remitente=usuariosDiccionario[socketUsuario]
        socketDestino.puts "-[Privado]-#{remitente}: #{orden[2]}"
      end

    when "PUBLICMESSAGE"
      mensaje=orden[1]
      if(mensaje==nil)
        socketUsuario.puts "Debes ingresar un mensaje"
      else
        usuariosDiccionario.keys.each do |usr|
          usr.puts "#{usuariosDiccionario[usr]}: #{mensaje}"
        end
      end


    when "CREATEROOM"

    when "INVITE"

    when "JOINROOM"

    when "ROOMESSAGE"

    when "DISCONNECT"
      usuariosDiccionario.delete(socketUsuario)
      socketUsuario.close
    else
      socketUsuario.puts "Comando no identificado, use HELP para mostrar los comandos"
    end


  end
  #Fin de la clase

end
