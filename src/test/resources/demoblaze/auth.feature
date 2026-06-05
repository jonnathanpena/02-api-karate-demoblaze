# Pruebas de API REST - Autenticacion Demoblaze
# Endpoint Signup : POST https://api.demoblaze.com/signup
# Endpoint Login  : POST https://api.demoblaze.com/login

Feature: Autenticacion en Demoblaze (Signup y Login)

  Background:
    * url baseUrl
    # Usuario unico por ejecucion para evitar conflictos en signup
    * def timestamp = function(){ return java.lang.System.currentTimeMillis() + '' }
    * def nuevoUsuario = 'sofka_qa_' + timestamp()
    * def passValido = 'SofkaQ4Test!'
    * def usuarioExistente = 'standard_test_user'

  # =====================================================================
  # SIGNUP
  # =====================================================================

  @signup @positivo
  Scenario: Crear un nuevo usuario exitosamente
    Given path '/signup'
    And request { username: '#(nuevoUsuario)', password: '#(passValido)' }
    When method POST
    Then status 200
    And print 'Signup response:', response
    # Demoblaze devuelve null en body cuando el signup es exitoso
    * def responseStr = response == null ? 'null' : response + ''
    * match responseStr != 'This user already exist.'

  @signup @negativo
  Scenario: Intentar crear un usuario ya existente retorna error
    Given path '/signup'
    # Intentamos registrar el mismo usuario dos veces
    And request { username: '#(usuarioExistente)', password: '#(passValido)' }
    When method POST
    Then status 200
    And print 'Signup duplicate response:', response
    # La API retorna el mensaje de error en el body
    * match response == 'This user already exist.'

  # =====================================================================
  # LOGIN
  # =====================================================================

  @login @positivo
  Scenario: Login con credenciales correctas retorna token de sesion
    # Primero creamos el usuario para garantizar que existe
    Given path '/signup'
    And request { username: '#(nuevoUsuario)', password: '#(passValido)' }
    When method POST
    Then status 200

    # Ahora hacemos login
    Given path '/login'
    And request { username: '#(nuevoUsuario)', password: '#(passValido)' }
    When method POST
    Then status 200
    And print 'Login response:', response
    # Login exitoso devuelve un token (string no nulo y no vacio)
    * match response != null
    * assert response.length > 0

  @login @negativo
  Scenario: Login con credenciales incorrectas retorna mensaje de error
    Given path '/login'
    And request { username: 'usuario_inexistente_xyz', password: 'clave_incorrecta' }
    When method POST
    Then status 200
    And print 'Login invalid response:', response
    # La API retorna mensaje de error cuando las credenciales son invalidas
    * match response == 'Wrong password.'
