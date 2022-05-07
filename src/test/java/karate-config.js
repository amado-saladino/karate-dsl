function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    URL: 'https://api.realworld.io/api'
  }
  if (env == 'dev') {
    config.EMAIL = "karate@email.com",
    config.PASSWORD = "karate123"
  } else if (env == 'e2e') {
    // customize
  }

  var accessToken = karate.callSingle('classpath:helpers/createToken.feature', config).authToken
  karate.configure('headers', {
    Authorization: `Token ${accessToken}`
    })
  return config;
}