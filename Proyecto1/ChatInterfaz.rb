require 'fox16'
include Fox

class ChatInterfaz < FXMainWindow
  def initialize(app)
    super(app,"PruebaChat",:width=>600,:height=>600)
    textArea = FXText.new(self, :opts => LAYOUT_EXPLICIT | TEXT_READONLY | TEXT_WORDWRAP,:width=>550,:height=>400,:x=>20,:y=>20)
    mensaje = FXTextField.new(self, 50,:opts => LAYOUT_EXPLICIT | TEXTFIELD_ENTER_ONLY,:width=>450,:height=>30,:x=>20,:y=>440)
    botonEnviar= FXButton.new(self, "Enviar",:opts => LAYOUT_EXPLICIT,:width=>100,:height=>30,:x=>490,:y=>440)

    botonEnviar.connect(SEL_COMMAND) do
      textArea.appendText(mensaje.text+"\n")
      mensaje.text=nil
    end
    mensaje.connect(SEL_COMMAND) do
      textArea.appendText(mensaje.text+"\n")
      mensaje.text=nil
    end
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
