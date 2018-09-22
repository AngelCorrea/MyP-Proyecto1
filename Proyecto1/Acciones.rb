require "./Instrucciones.rb"
require "./Sala.rb"
require "./Usuario.rb"
class Acciones
  @@rooms=[] #Arreglo para salas (nombreSala,usuariosLista)

#Metodo de busqueda por medio de socket/
#Devuelve uno objeto usuario si se encuentra, si no, nil
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

  #Metodo de busqueda por medio de nombre de usuario/
  #Devuelve uno objeto usuario si se encuentra, si no, nil
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
  #Metodo para verificar la existencia de una sala, por su nombre.
  #Devuelve true si la sala existe, false en otro caso
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

  #Metodo para buscar una sala por su nombre.
  #Devuelve la sala si la encuentra, nil en otro caso
  def getSala(nombre)
    for i in @@rooms
      if i.name == nombre
        return i
      else
        next
      end
    end
    return nil
  end

  #Metodo para verificar la existencia de un nombre registrado
  #Devuelve true si existe el nombre, false en otro caso.
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
  #Metodo para identificar un usuario.
  #-comando- Tipo String
  #-usuariosLista- Tipo Arreglo
  #-socketUsuario- Socket del usuario
  #Verificamos si el comando esta en la estructura que se solicita,
  #Si lo esta y su nombre no se repite, creamos un objeto "usuario", asociandole
  #su socket, su nombre, un estado predefinido como [ACTIVE] y lo
  #agregamos a la lista de usuarios.
  def accionIdentify(comando,usuariosLista,socketUsuario)
    orden=comando.split(" ")
    username=orden[1]
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

  #Metodo para cambiar el status de un usuario
  #-comando- Tipo String
  #-usuariosLista- Tipo Arreglo
  #-socketUsuario- Socket del usuario
  #Verificamos que el comando que nos manda contenga un estado valido
  #(ACTIVE AWAY BUSY) si cumple con esto, buscamos al usuario registrado
  #y le cambiamos su estado.

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

  #Metodo para consultar la lista de usuarios identificados.
  #-usuariosLista- Tipo Arreglo
  #-socketUsuario- Socket del usuario
  #Devolvemos la lista de usuarios en una sola cadena.
  def accionUsers(usuariosLista,socketUsuario)
    s="Usuarios Identificados: \n"
    for i in usuariosLista
      s=s+"[#{i.status}]"+i.name+"\n"
    end
    socketUsuario.puts s
  end

  #Metodo para enviar mensajes privados
  #-comando- Tipo String
  #-usuariosLista- Tipo Arreglo
  #-socketUsuario- Socket del usuario
  #Comprobamos que el usuario que envia el mensaje y al que le llegara esten
  #registrados, si lo estan, buscamos al usuario que envia y al que recibe,
  #mandamos su nombre concatenado a el mensaje, y se lo mandamos al socket del
  #usuario receptor.
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
      usr.socket.puts "-[Privado]-#{usr.name}: #{mensaje[2]}"
      usrDestino.socket.puts "-[Privado]-#{usr.name}: #{mensaje[2]}"
    end
  end
  #Metodo para mensajes publicos
  #-comando- Tipo String
  #-usuariosLista- Tipo Arreglo
  #-socketUsuario- Socket del usuario
  #Recibimos el mensaje, si el usuario esta identificado, adjuntamos su nombre
  #y el mensaje e iteramos sobre "usuariosLista" enviandoselo a todos los socket
  #de la lista.
  def accionPublicMessage(comando,usuariosLista,socketUsuario)
    mensaje=comando.split(" ",2)
    usr=buscaUsuarioPorSocket(usuariosLista,socketUsuario)
    if (usr.equal? nil)
      socketUsuario.puts "Debes identificarte primero con \"IDENTIFY nombre\""
    elsif(mensaje[1]==nil)
      socketUsuario.puts "Debes ingresar un mensaje"
    else
      for cliente in usuariosLista
        if(cliente.respond_to? "socket")
          cliente.socket.puts "#{usr.name}: #{mensaje[1]}"
        else
          next
        end
      end
    end
  end

  #Metodo para crear salas de chat
  #-comando- Tipo String
  #-usuariosLista- Tipo Arreglo
  #-socketUsuario- Socket del usuario
  #Verificamos si el usuario esta identificado, si lo esta, de "comando",
  #revisamos si el nombre de la sala no esta ocupado, si no lo esta, creamos el
  #objeto Sala, a la que se le asigna un arreglo/lista y su nombre.
  #Siempre se agrega primero al que creo la sala, por lo que el sera el admin.
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

  #Metodo para mandar un mensaje a una sala de chat
  #-comando- Tipo String
  #-usuariosLista- Tipo Arreglo
  #-socketUsuario- Socket del usuario
  #Verificamos en "comando" que la redaccion del comando sea correcta, revisamos
  #que la sala exista, y si existe, mandamos el mensaje a todos los usuarios
  #conectados en la sala por medios de sus sockets
  def accionRoomMessage(comando,usuariosLista,socketUsuario)
    orden=comando.split(" ",3)
    nombreSala=orden[1]
    mensaje=orden[2]
    usuario=buscaUsuarioPorSocket(usuariosLista,socketUsuario)
    sala=getSala(nombreSala)
    if(nombreSala==nil)
      socketUsuario.puts "Debes ingresar el nombre de una sala"
    elsif (!existeSala?(nombreSala))
      socketUsuario.puts "La sala no existe"
    elsif (buscaUsuarioPorSocket(sala.lista,socketUsuario)==nil)
      socketUsuario.puts "No perteneces a esta sala"
    else
      accionPublicMessage("_ #{orden[2]}",sala.lista,socketUsuario)
    end
  end
  #Metodo para invitar usuarios a una sala de chat
  #-comando- Tipo String
  #-usuariosLista- Tipo Arreglo
  #-socketUsuario- Socket del usuario
  #Verificamos que la sala exista, si existe, verificamos que seas el admin.
  #si no eres el admin, no puedes invitar a nadie. Enviamos un mensaje a los
  #usuarios que esten conectados haciendoles saber de la invitacion, y agregamos
  #su nombre como "clave", para que cuando acepten, quitar el nombre e
  #identificarlos
  def accionInvite(comando,usuariosLista,socketUsuario)
    orden=comando.split(" ")
    nombreSala=orden[1]
    sala=getSala(nombreSala)
    admin=buscaUsuarioPorSocket(usuariosLista,socketUsuario)
    usuariosChat=nil
    if(sala.respond_to? "lista")
      usuariosChat=sala.lista
    end
    if(sala == nil)
      socketUsuario.puts "La sala #{nombreSala} no existe."
    elsif (usuariosChat[0].== admin)
      socketUsuario.puts "No eres el dueño de la sala"
    elsif (orden[2] == nil)
      socketUsuario.puts "Debes escribir el nombre de un usuario conectado"
    else
      i=2
      usuariosOff="Estos usuarios no se encontraron: \n"
      while i < orden.length
        usr=buscaUsuarioPorNombre(usuariosLista,orden[i])
        if(usr == nil)
          usuariosOff=usuariosOff+ "#{orden[i]}"
        else
          invitado=buscaUsuarioPorNombre(usuariosLista,orden[i])
          invitado.socket.puts "#{usuariosChat[0].name} te a invitado a la sala [#{sala.name}]"
          usuariosChat.push (orden[i])
        end
        i=i+1
      end
      if("Estos usuarios no se encontraron: \n" != usuariosOff)
        socketUsuario.puts usuariosOff
      end
    end
  end

  #Metodo para que un usuario invitado a una sala pueda unirse
  #-comando- Tipo String
  #-usuariosLista- Tipo Arreglo
  #-socketUsuario- Socket del usuario
  #Verificamos que la sala exista, que su nombre este en la lista de usuarios,
  #y si lo esta, quitamos el nombre, e identificamos al usuario dentro de la
  #lista de usuarios de la sala, asociandole un objeto "usuario"
  def accionJoinRoom(comando,usuariosLista,socketUsuario)
    orden=comando.split(" ")
    nombreSala=orden[1]
    usuario=buscaUsuarioPorSocket(usuariosLista,socketUsuario)
    sala=getSala(nombreSala)
    salaLista=sala.lista
    if (sala == nil)
      socketUsuario.puts "Esta sala no existe"
    elsif (!salaLista.include?(usuario.name))
      socketUsuario.puts "No fuiste invitado a la sala"
    else
      salaLista.delete(usuario.name)
      accionIdentify("_ [#{nombreSala}]#{usuario.name}",salaLista,socketUsuario)
    end
  end

  #Metodo para desconectar usuarios.
  #-usuariosLista- Tipo Arreglo
  #-socketUsuario- Socket del usuario
  #Para la lista de salas, buscamos al usuarios, si es que existe en alguna de
  #ellas y lo eliminamos.
  #Lo eliminamos de la lista de usuarios en general y cerramos su socket
  def accionDisconnect(usuariosLista,socketUsuario)
    usr=buscaUsuarioPorSocket(usuariosLista,socketUsuario)
    for i in @@rooms
      if i.lista.include?(usr)
        i.lista.delete(usr)
      else
        next
      end
    end
    usuariosLista.delete(usr)
    socketUsuario.close
  end

  #Metodo que filtrara la cadena enviada, y ejecutara la accion solicitada
  #-comando- Tipo String
  #-usuariosLista- Tipo Arreglo
  #-socketUsuario- Socket del usuario
  #Dividimoss la cadena "comando" y el primer elemento siempre debera de ser
  #la instruccion que quiere ejecutarse, de no ser valida, se le enviara un
  #mensaje al cliente, en otro caso, se llamara al metodo correspondiente.
  def comandos(comando,usuariosLista,socketUsuario)
    begin
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
        accionInvite(comando,usuariosLista,socketUsuario)
      when "JOINROOM"
        accionJoinRoom(comando,usuariosLista,socketUsuario)
      when "ROOMESSAGE"
        accionRoomMessage(comando,usuariosLista,socketUsuario)
      when "DISCONNECT"
        accionDisconnect(usuariosLista,socketUsuario)
      else
        socketUsuario.puts "Comando no identificado, use HELP para mostrar los comandos"
      end
    rescue IOError
      puts "Un usuario se a desconectado"
    end
  end
  #Fin de la clase.
end
