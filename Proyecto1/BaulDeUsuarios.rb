class Baul
  usuarios=Array.new
  def addUser(name,usuarios)
    return usuarios.push(name)
  end
end
  puts usuarios.length #Deberia devolver 0
  addUser("MrTest",usuarios)

  puts usuarios.length #Deberia devolver 1
