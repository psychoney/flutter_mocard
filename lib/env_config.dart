enum Env { prod, dev, test }

class EnvConfig {
  static Env env = Env.dev;

  static String getBaseUrl(Env env) {
    switch (env) {
      case Env.prod:
        return "https://your-production-api.com/";
      case Env.dev:
        return "https://your-development-api.com/";
      case Env.test:
        return "https://your-test-api.com/";
      default:
        return "https://your-development-api.com/";
    }
  }
}
