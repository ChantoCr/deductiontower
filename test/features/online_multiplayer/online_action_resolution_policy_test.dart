import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_participant.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/online_action_resolution_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnlineActionResolutionPolicy', () {
    const policy = OnlineActionResolutionPolicy();

    final hostSession = OnlineRoomSession(
      roomCode: 'AB12CD',
      localParticipantId: 'host_1',
      participants: const [
        OnlineRoomParticipant(
          id: 'host_1',
          displayName: 'Host',
          role: OnlineRoomParticipantRole.host,
          connectionState: OnlineRoomParticipantConnectionState.connected,
          isLocalPlayer: true,
          isReady: true,
        ),
        OnlineRoomParticipant(
          id: 'guest_1',
          displayName: 'Guest',
          role: OnlineRoomParticipantRole.guest,
          connectionState: OnlineRoomParticipantConnectionState.connected,
          isLocalPlayer: false,
          isReady: true,
        ),
      ],
      phase: OnlineRoomPhase.readyToSync,
      createdAt: DateTime.parse('2026-06-16T10:00:00.000Z'),
    );

    final guestSession = OnlineRoomSession(
      roomCode: 'AB12CD',
      localParticipantId: 'guest_1',
      participants: const [
        OnlineRoomParticipant(
          id: 'host_1',
          displayName: 'Host',
          role: OnlineRoomParticipantRole.host,
          connectionState: OnlineRoomParticipantConnectionState.connected,
          isLocalPlayer: false,
          isReady: true,
        ),
        OnlineRoomParticipant(
          id: 'guest_1',
          displayName: 'Guest',
          role: OnlineRoomParticipantRole.guest,
          connectionState: OnlineRoomParticipantConnectionState.connected,
          isLocalPlayer: true,
          isReady: true,
        ),
      ],
      phase: OnlineRoomPhase.readyToSync,
      createdAt: DateTime.parse('2026-06-16T10:00:00.000Z'),
    );

    test('host-only authority allows the host client to resolve queued actions', () {
      final canResolve = policy.canLocalClientResolveQueuedActions(
        authority: OnlineActionResolutionAuthority.hostClient,
        session: hostSession,
      );

      expect(canResolve, isTrue);
      expect(
        policy.waitingLabel(
          authority: OnlineActionResolutionAuthority.hostClient,
          session: hostSession,
        ),
        'Host can resolve',
      );
    });

    test('host-only authority blocks the guest client from resolving queued actions', () {
      final canResolve = policy.canLocalClientResolveQueuedActions(
        authority: OnlineActionResolutionAuthority.hostClient,
        session: guestSession,
      );

      expect(canResolve, isFalse);
      expect(
        policy.waitingLabel(
          authority: OnlineActionResolutionAuthority.hostClient,
          session: guestSession,
        ),
        'Waiting for host resolver',
      );
    });

    test('backend authority keeps resolution off the local client', () {
      final canResolve = policy.canLocalClientResolveQueuedActions(
        authority: OnlineActionResolutionAuthority.backendService,
        session: hostSession,
      );

      expect(canResolve, isFalse);
      expect(
        policy.waitingLabel(
          authority: OnlineActionResolutionAuthority.backendService,
          session: hostSession,
        ),
        'Waiting for backend resolver',
      );
    });
  });
}
