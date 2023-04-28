import 'package:grpc/grpc.dart';

class GrpcConfig {
  final ClientChannel _clientChannel;
  GrpcConfig()
      : _clientChannel = ClientChannel('localhost',
            port: 50051,
            options: const ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ));

  ClientChannel get clientChannel => _clientChannel;
}
