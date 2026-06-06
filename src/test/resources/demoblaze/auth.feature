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
    And match response == '#string'

  @signup @negativo
  Scenario: Intentar crear un usuario ya existente retorna error
    Given path '/signup'
    # Intentamos registrar el mismo usuario dos veces
    And request { username: '#(usuarioExistente)', password: '#(passValido)' }
    When method POST
    Then status 200
    And print 'Signup duplicate response:', response
    # La API retorna el mensaje de error como objeto JSON
    * match response == {errorMessage: 'This user already exist.'}
    And match response == read('classpath:demoblaze/schemas/error-response-schema.json')

  # =====================================================================
  # LOGIN
  # =====================================================================

  @login @positivo
  Scenario: Login con credenciales correctas retorna token de sesion
    # Prerrequisito de entorno: 'standard_test_user' es un usuario preexistente gestionado
    # externamente (no por este escenario); la cuenta debe existir en Demoblaze antes de la ejecucion.
    Given path '/login'
    And request { username: '#(usuarioExistente)', password: '#(passValido)' }
    When method POST
    Then status 200
    And print 'Login response:', response
    # Login exitoso devuelve un token (string no nulo y no vacio)
    * match response != null
    * assert response.length > 0
    And match response == '#string'

  @login @negativo
  Scenario: Login con credenciales incorrectas retorna mensaje de error
    Given path '/login'
    And request { username: 'usuario_inexistente_xyz', password: 'clave_incorrecta' }
    When method POST
    Then status 200
    And print 'Login invalid response:', response
    # La API retorna mensaje de error cuando las credenciales son invalidas
    * match response == {errorMessage: 'User does not exist.'}
    And match response == read('classpath:demoblaze/schemas/error-response-schema.json')
