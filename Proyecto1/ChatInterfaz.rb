require 'fox16'
require './Cliente.rb'
require 'socket'
include Fox

class ChatInterfaz < FXMainWindow
  def initialize(app)

    super(app,"PruebaChat",:width=>1000,:height=>670)
    entradaIP =ARGV
    ip=entradaIP[0]
    port=entradaIP[1]

    socket = TCPSocket.open(ip, port) # host / puerto
    cliente=Cliente.new(socket)
    fondo=FXLabel.new(self,"",:opts => LAYOUT_FILL)
    fondo.backColor="DarkCyan"
    @@textArea = FXText.new(self, :opts => LAYOUT_EXPLICIT | TEXT_READONLY | TEXT_WORDWRAP,:width=>550,:height=>400,:x=>20,:y=>20)


    mensaje = FXTextField.new(self, 50,:opts => LAYOUT_EXPLICIT | TEXTFIELD_ENTER_ONLY,:width=>450,:height=>30,:x=>20,:y=>440)

    botonEnviar= FXButton.new(self, "Enviar",:opts => LAYOUT_EXPLICIT,:width=>50,:height=>30,:x=>500,:y=>440)
    botonEnviar.backColor="LightCyan"
    botonUsuarios= FXButton.new(self, "Usuarios",:opts => LAYOUT_EXPLICIT,:width=>100,:height=>20,:x=>600,:y=>40)
    @groupBox=FXGroupBox.new(self, "Opciones de mensajes",:opts => LAYOUT_EXPLICIT|GROUPBOX_TITLE_CENTER | FRAME_RIDGE,:width=>200,:height=>100,:x=>580,:y=>420)
    botonUsuarios.backColor="LightCyan"
    @groupBox.backColor="LightCyan2"


    @dataTarget=FXDataTarget.new(2)
    @tipoComando=""
    @dataTarget.connect(SEL_COMMAND) do
      if(@dataTarget.value==0)
        @@textArea.appendText("Entro al modo de comandos manuales\n")
        @tipoComando=""
      elsif (@dataTarget.value==1)
        @@textArea.appendText("Sus mensajes ahora seran publicos\n")
        @tipoComando="PUBLICMESSAGE "
      elsif (@dataTarget.value==2)
        @@textArea.appendText("Introduzca el nombre de su sala y despues su mensaje-\nEj. Sala1 Hola sala1\n")
        @tipoComando="ROOMESSAGE "
      end
    end
    botonUsuarios.connect(SEL_COMMAND) do
      cliente.enviarMensaje("USERS"+"\n")
    end

    botonEnviar.connect(SEL_COMMAND) do
      cliente.enviarMensaje(@tipoComando+mensaje.text+"\n")
      mensaje.text=nil
    end

    mensaje.connect(SEL_COMMAND) do
      cliente.enviarMensaje(@tipoComando+mensaje.text)
      mensaje.text=nil
    end
    tipoOtroComando=FXRadioButton.new(@groupBox, "Comandos manuales",@dataTarget,FXDataTarget::ID_OPTION)
    tipoOtroComando.backColor="LightCyan2"
    tipoMensajePublico=FXRadioButton.new(@groupBox,"Mensaje Publico",@dataTarget,FXDataTarget::ID_OPTION+1)
    tipoMensajePublico.backColor="LightCyan2"
    tipoMensajeGrupo=FXRadioButton.new(@groupBox,"Mensaje a grupo",@dataTarget,FXDataTarget::ID_OPTION+2)
    tipoMensajeGrupo.backColor="LightCyan2"
    entradaMensajes=Thread.new{
      while msg= cliente.entrada()
        @@textArea.appendText(msg)
      end
    }
  end
  def create
    super
    show(PLACEMENT_SCREEN)
  end
end


app=FXApp.new
ChatInterfaz.new(app)
app.create
app.run
