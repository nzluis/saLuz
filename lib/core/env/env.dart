import 'package:meta/meta.dart';

@immutable
sealed class Environment {
  const Environment({
    required this.name,
    required this.apiBaseUrl,
    required this.pubmedBaseUrl,
    required this.pubmedApiKey,
    required this.groqApiKey,
    required this.enableOfflineMode,
    required this.logLevel,
  });

  final String name;
  final String apiBaseUrl;
  final String pubmedBaseUrl;
  final String pubmedApiKey;
  final String groqApiKey;
  final bool enableOfflineMode;
  final LogLevel logLevel;

  static const dev = DevEnvironment();
  static const staging = StagingEnvironment();
  static const prod = ProductionEnvironment();

  static Environment fromName(String name) {
    return switch (name) {
      'dev' => dev,
      'staging' => staging,
      'prod' => prod,
      _ => throw ArgumentError('Unknown environment: $name'),
    };
  }
}

final class DevEnvironment extends Environment {
  const DevEnvironment()
      : super(
          name: 'dev',
          apiBaseUrl: 'http://localhost:3000',
          pubmedBaseUrl: 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils',
          pubmedApiKey: '',
          groqApiKey: '',
          enableOfflineMode: true,
          logLevel: LogLevel.debug,
        );
}

final class StagingEnvironment extends Environment {
  const StagingEnvironment()
      : super(
          name: 'staging',
          apiBaseUrl: 'https://api-staging.saluz.app',
          pubmedBaseUrl: 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils',
          pubmedApiKey: '',
          groqApiKey: '',
          enableOfflineMode: true,
          logLevel: LogLevel.info,
        );
}

final class ProductionEnvironment extends Environment {
  const ProductionEnvironment()
      : super(
          name: 'prod',
          apiBaseUrl: 'https://api.saluz.app',
          pubmedBaseUrl: 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils',
          pubmedApiKey: '',
          groqApiKey: '',
          enableOfflineMode: true,
          logLevel: LogLevel.warning,
        );
}

enum LogLevel { debug, info, warning, error }
