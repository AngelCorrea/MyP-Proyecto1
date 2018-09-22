require 'fox16'
require './Cliente.rb'
require 'socket'
include Fox

  #Clase para la interfaz grafica del chat
class ChatInterfaz < FXMainWindow
  #Metodo constructor.
  def initialize(app)
    #Establecemos las dimensiones de la ventana al iniciar.
    super(app,"ChatEnRuby",:width=>1000,:height=>670)
    #Recibimos la ip y el puerto desde la entrada estandar.
    entradaIP =ARGV
    ip=entradaIP[0]
    port=entradaIP[1]
    #__________________________________________
    #Creamos el socket a partir de la ip y el puerto que recibimos
    socket = TCPSocket.open(ip, port) # host / puerto
    #Creamos un objeto cliente con el socket que creamos
    cliente=Cliente.new(socket)
    #Fondo para la interfaz grafica (Cubrira toda la ventana y establecemos
    #su color)
    fondo=FXLabel.new(self,"",:opts => LAYOUT_FILL)
    fondo.backColor="DarkCyan"

    #Declaramos el area donde se publicaran los mensajes recibidos por el
    #servidor.
    @@textArea = FXText.new(self, :opts => LAYOUT_EXPLICIT | TEXT_READONLY |
      TEXT_WORDWRAP,:width=>550,:height=>400,:x=>20,:y=>20)
    #Campo de texto por donde recibiremos los mensajes de el usuario que ocupe
    #esta interfaz
    mensaje = FXTextField.new(self, 50,:opts => LAYOUT_EXPLICIT |
      TEXTFIELD_ENTER_ONLY,:width=>450,:height=>30,:x=>20,:y=>440)

    #Boton de interaccion enviar mensaje
    botonEnviar= FXButton.new(self, "Enviar",
      :opts => LAYOUT_EXPLICIT,:width=>50,:height=>30,:x=>500,:y=>440)
    botonEnviar.backColor="LightCyan"
    #Boton de interaccion que imprime la lista de usuarios en pantalla.
    botonUsuarios= FXButton.new(self, "Usuarios",
      :opts => LAYOUT_EXPLICIT,:width=>100,:height=>20,:x=>600,:y=>40)
    botonUsuarios.backColor="LightCyan"

    #Grupo de botones circulares, para escoger el tipo de mensaje
    #que querremos enviar (comandos, publico o a un cuarto)
    @groupBox=FXGroupBox.new(self, "Opciones de mensajes",
      :opts => LAYOUT_EXPLICIT|GROUPBOX_TITLE_CENTER | FRAME_RIDGE,
      :width=>200,:height=>100,:x=>580,:y=>420)
    @groupBox.backColor="LightCyan2"
    @dataTarget=FXDataTarget.new(2)

    #Manera de cambiar el tipo de mensaje, dependiendo de el boton que se
    #encuentre presionado
    @tipoComando=""
    @dataTarget.connect(SEL_COMMAND) do
      if(@dataTarget.value==0)
        @@textArea.appendText("Entro al modo de comandos manuales\n")
        @tipoComando=""
      elsif (@dataTarget.value==1)
        @@textArea.appendText("Sus mensajes ahora seran publicos\n")
        @tipoComando="PUBLICMESSAGE "
      elsif (@dataTarget.value==2)
        @@textArea.appendText("Introduzca el nombre de su sala y"+
          " despues su mensaje-\nEj. Sala1 Hola sala1\n")
        @tipoComando="ROOMESSAGE "
      end
    end

    #Accion que realiza el boton "Usuarios" al ser presionado
    #Manda un mensaje al servidor con el comando USERS
    botonUsuarios.connect(SEL_COMMAND) do
      cliente.enviarMensaje("USERS"+"\n")
    end

    #Accion que realiza el boton "Enviar" cuando se presiona
    #Envia lo que sea que haya en el campo de texto "mensaje" y despues vacia
    #la entrada
    botonEnviar.connect(SEL_COMMAND) do
      cliente.enviarMensaje(@tipoComando+mensaje.text+"\n")
      mensaje.text=nil
    end

    #Accion que se realiza al apretar "enter" mientras el puntero esta activo
    #en el campo de texto.
    #Manda la cadena que este en el campo de texto y despues la vacia
    mensaje.connect(SEL_COMMAND) do
      cliente.enviarMensaje(@tipoComando+mensaje.text)
      mensaje.text=nil
    end
    #Declaracion de los botones para escoger que tipo de mensaje se quieren
    #enviar
    #---------------------------------------------------------------------
    tipoOtroComando=FXRadioButton.new(@groupBox,
      "Comandos manuales",@dataTarget,FXDataTarget::ID_OPTION)
    tipoOtroComando.backColor="LightCyan2"
    tipoMensajePublico=FXRadioButton.new(@groupBox,
      "Mensaje Publico",@dataTarget,FXDataTarget::ID_OPTION+1)
    tipoMensajePublico.backColor="LightCyan2"
    tipoMensajeGrupo=FXRadioButton.new(@groupBox,
      "Mensaje a grupo",@dataTarget,FXDataTarget::ID_OPTION+2)
    tipoMensajeGrupo.backColor="LightCyan2"
    #---------------------------------------------------------------------
    #Hilo ejecutandose para escribir en pantalla las entradas del servidor
    entradaMensajes=Thread.new{
      while msg= cliente.entrada()
        @@textArea.appendText(msg)
      end
    }
  end
  #Fin del metodo initialize

  def create
    super
    show(PLACEMENT_SCREEN)
  end
end


app=FXApp.new
ChatInterfaz.new(app)
app.create
app.run
