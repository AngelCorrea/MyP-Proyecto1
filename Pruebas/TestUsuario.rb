require 'minitest/autorun'
require 'minitest/spec'

$:.unshift File.expand_path(File.dirname(__FILE__) + '/..')

require 'Usuario'
describe Usuario do
  subject{ Usuario.new }
###########################################
  it "Ser instancia de la clase usuario" do
    subject.must_be_instance_of Usuario
  end
###########################################
  it "TestUsuarioSetNombre" do
    usr1= Usuario.new
    usr1.setNombre("Mr. Test")
    usr1.nombre.must_equal "Mr. Test"
  end
##########################################
  it "TestUsuarioGetNombre" do
  usr1= Usuario.new
  usr1.setNombre("Mr. Test")
  usr1.getNombre.must_equal "Mr. Test"
  end
#########################################

end
