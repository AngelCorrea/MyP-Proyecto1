require 'fox16'
require './Cliente.rb'
include Fox

class ChatInterfaz < FXMainWindow
  def initialize(app)
    super(app,"PruebaChat",:width=>700,:height=>600)
    @@textArea = FXText.new(self, :opts => LAYOUT_EXPLICIT | TEXT_READONLY | TEXT_WORDWRAP,:width=>550,:height=>400,:x=>20,:y=>20)
    mensaje = FXTextField.new(self, 50,:opts => LAYOUT_EXPLICIT | TEXTFIELD_ENTER_ONLY,:width=>450,:height=>30,:x=>20,:y=>440)
    botonEnviar= FXButton.new(self, "Enviar",:opts => LAYOUT_EXPLICIT,:width=>100,:height=>30,:x=>490,:y=>440)
    botonEnviar.connect(SEL_COMMAND) do
      Cliente.new.enviarMensaje(mensaje.text+"\n")
      mensaje.text=nil
    end

    mensaje.connect(SEL_COMMAND) do
      Cliente.new.enviarMensaje(mensaje.text)
      mensaje.text=nil
    end
    entradaMensajes=Thread.new{
      while msg= Cliente.new.entrada()
         @@textArea.appendText(msg)
      end
    }
  end
  def create
    super
    show(PLACEMENT_SCREEN)
  end
end

Cliente.new()
app=FXApp.new
ChatInterfaz.new(app)
app.create
app.run
