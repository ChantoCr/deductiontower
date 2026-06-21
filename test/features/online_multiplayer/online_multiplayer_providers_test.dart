import 'package:anime_deduction_tower/features/online_multiplayer/data/config/online_backend_target.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/firebase_online_room_preview_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/supabase_online_room_preview_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('online multiplayer providers', () {
    test('defaults to the mock preview datasource', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final dataSource = container.read(onlineRoomDataSourceProvider);
      final repository = container.read(onlineRoomRepositoryProvider);
      final session = repository.createRoom(hostPlayerName: 'Host');

      expect(dataSource, isA<MockOnlineRoomDataSource>());
      expect(session.phase, OnlineRoomPhase.waitingForOpponent);
      expect(session.isHost, isTrue);
    });

    test('supports a Firebase preview adapter override', () {
      final container = ProviderContainer(
        overrides: [
          onlineBackendTargetProvider.overrideWithValue(
            OnlineBackendTarget.firebasePreview,
          ),
        ],
      );
      addTearDown(container.dispose);

      final dataSource = container.read(onlineRoomDataSourceProvider);
      final repository = container.read(onlineRoomRepositoryProvider);
      final session = repository.joinRoomPreview(
        roomCode: 'ab12cd',
        guestPlayerName: 'Guest',
      );

      expect(dataSource, isA<FirebaseOnlineRoomPreviewDataSource>());
      expect(session.roomCode, 'AB12CD');
      expect(session.phase, OnlineRoomPhase.waitingForReady);
      expect(session.isHost, isFalse);
    });

    test('supports a Supabase preview adapter override', () {
      final container = ProviderContainer(
        overrides: [
          onlineBackendTargetProvider.overrideWithValue(
            OnlineBackendTarget.supabasePreview,
          ),
        ],
      );
      addTearDown(container.dispose);

      final dataSource = container.read(onlineRoomDataSourceProvider);
      final repository = container.read(onlineRoomRepositoryProvider);
      final session = repository.createRoom(hostPlayerName: 'Host');
      final updated = repository.setLocalParticipantReady(
        session: session,
        isReady: true,
      );

      expect(dataSource, isA<SupabaseOnlineRoomPreviewDataSource>());
      expect(updated.localParticipant.isReady, isTrue);
      expect(updated.phase, OnlineRoomPhase.waitingForOpponent);
    });

    test('keeps host-client authority by default on the Firebase backend', () {
      final container = ProviderContainer(
        overrides: [
          onlineBackendTargetProvider.overrideWithValue(
            OnlineBackendTarget.firebaseBackend,
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(onlineActionResolutionAuthorityProvider),
        OnlineActionResolutionAuthority.hostClient,
      );
    });

    test(
        'can switch the Firebase backend into backend-authority migration mode',
        () {
      final container = ProviderContainer(
        overrides: [
          onlineBackendTargetProvider.overrideWithValue(
            OnlineBackendTarget.firebaseBackend,
          ),
          onlineUseBackendResolutionAuthorityProvider.overrideWithValue(true),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(onlineActionResolutionAuthorityProvider),
        OnlineActionResolutionAuthority.backendService,
      );
    });

    test('does not activate backend authority for preview adapters', () {
      final container = ProviderContainer(
        overrides: [
          onlineBackendTargetProvider.overrideWithValue(
            OnlineBackendTarget.firebasePreview,
          ),
          onlineUseBackendResolutionAuthorityProvider.overrideWithValue(true),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(onlineActionResolutionAuthorityProvider),
        OnlineActionResolutionAuthority.hostClient,
      );
    });
  });
}
