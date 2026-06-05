function fn() {
  var env = karate.env || 'dev';
  karate.log('Entorno activo:', env);

  var config = {
    baseUrl: 'https://api.demoblaze.com',
    signupUrl: 'https://api.demoblaze.com/signup',
    loginUrl: 'https://api.demoblaze.com/login'
  };

  if (env === 'staging') {
    config.baseUrl = 'https://api-staging.demoblaze.com';
  }

  karate.configure('connectTimeout', 10000);
  karate.configure('readTimeout', 15000);
  karate.configure('ssl', true);
  
  // Enable verbose logging
  karate.configure('logPrettyRequest', true);
  karate.configure('logPrettyResponse', true);

  return config;
}
