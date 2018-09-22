class Instrucciones
  #Clase Instrucciones
  #Metodo para devolver las instrucciones de ayuda.
  #Devuelve las instrucciones de ayuda.
  def instruccionesAyuda()
    return "• IDENTIFY username\n
    Este comando identifica al usuario, username será el nombre del usuario, ejemplo: IDENTIFY Kimberly\n
    • STATUS userstatus\n
    Este comando asignará el estado al usuario, userstatus es uno de los tres posibles estados, ejemplo: STATUS AWAY\n
    • USERS\n
    Mostrará los usuarios identificados, ejemplo: USERS\n
    • MESSAGE username messageContent\n
    Enviará un mensaje privado a username, y el mensaje será messageContent, ejemplo: MESSAGE Luis Hola Luis\n
    • PUBLICMESSAGE messageContent\n
    Enviará el mensaje a todos los usuarios identificados, ejemplo: PUBLICMESSAGE Hola a todos!\n
    • CREATEROOM roomname\n
    Se creará una sala en el servidor con nombre roomname y el dueño de la sala será el que la creó, ejemplo:\n
    CREATEROOM SALA1\n
    • INVITE roomname username1 username2,...\n
    Enviará una invitación a la lista de usuarios para unirse a la sala roomname, ejemplo: INVITE SALA1 LUIS\n
    KIM FER\n
    • JOINROOM roomname\n
    Aceptará la invitación a la sala roomname que fue invitado, JOINROOM SALA1\n
    • ROOMESSAGE roomname messageContent\n
    Enviará el mensaje a todos los usuarios dentro de esa sala, ejemplo: ROOMESSAGE sala1 Hola sala1!\n
    • DISCONNECT\n
    El usuario se desconecta del servidor, ejemplo: DISCONNECT\n"
  end

end
#Fin de la clase
