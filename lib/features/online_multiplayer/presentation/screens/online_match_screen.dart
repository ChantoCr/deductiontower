import 'package:anime_deduction_tower/features/online_multiplayer/data/config/online_backend_target.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_participant.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/presentation/controllers/online_lobby_controller.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/presentation/widgets/online_bootstrap_preview_card.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_badge.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:anime_deduction_tower/shared/widgets/app_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnlineMatchScreen extends ConsumerStatefulWidget {
  const OnlineMatchScreen({super.key});

  @override
  ConsumerState<OnlineMatchScreen> createState() => _OnlineMatchScreenState();
}

class _OnlineMatchScreenState extends ConsumerState<OnlineMatchScreen> {
  late final TextEditingController _playerNameController;
  late final TextEditingController _joinCodeController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onlineLobbyControllerProvider);
    _playerNameController = TextEditingController(text: state.playerName);
    _joinCodeController = TextEditingController(text: state.joinCode);
  }

  @override
  void dispose() {
    _playerNameController.dispose();
    _joinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onlineLobbyControllerProvider);
    final controller = ref.read(onlineLobbyControllerProvider.notifier);
    final backendTarget = ref.watch(onlineBackendTargetProvider);
    final usesFirebaseBackend =
        backendTarget == OnlineBackendTarget.firebaseBackend;
    final supportsMockSimulation = !usesFirebaseBackend;

    if (_playerNameController.text != state.playerName) {
      _playerNameController.value = _playerNameController.value.copyWith(
        text: state.playerName,
        selection: TextSelection.collapsed(offset: state.playerName.length),
      );
    }

    if (_joinCodeController.text != state.joinCode) {
      _joinCodeController.value = _joinCodeController.value.copyWith(
        text: state.joinCode,
        selection: TextSelection.collapsed(offset: state.joinCode.length),
      );
    }

    return AppScaffold(
      title: 'Online Match Foundation',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useWideLayout = constraints.maxWidth >= 980;

          final heroCard = AppCard(
            glowColor: AppColors.secondary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'ONLINE FOUNDATION',
                    style: AppTextStyles.label,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  state.isHostMode
                      ? 'Create a room-code lobby preview.'
                      : 'Preview a room join flow.',
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  state.isHostMode
                      ? 'This host flow previews how a room owner can generate a shareable code, wait for an opponent, and later hand off to realtime room membership without changing the existing game-rule architecture.'
                      : 'This join flow previews how a remote player can enter a normalized code, inspect guest-side lobby state, and prepare for future backend-based session syncing.',
                  style: AppTextStyles.subtitle.copyWith(height: 1.45),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    const AppBadge(
                      icon: Icons.key_outlined,
                      label: 'Room-code flow',
                      accent: AppColors.secondary,
                    ),
                    const AppBadge(
                      icon: Icons.cloud_sync_outlined,
                      label: 'Realtime sync later',
                      accent: AppColors.accent,
                    ),
                    AppBadge(
                      icon: state.isHostMode
                          ? Icons.add_home_work_outlined
                          : Icons.login_rounded,
                      label:
                          state.isHostMode ? 'Host preview' : 'Guest preview',
                      accent: AppColors.primary,
                    ),
                    AppBadge(
                      icon: Icons.storage_rounded,
                      label: backendTarget.label,
                      accent: AppColors.success,
                    ),
                  ],
                ),
              ],
            ),
          );

          final modeCard = _LobbyModeCard(
            selectedMode: state.lobbyMode,
            onModeSelected: controller.updateLobbyMode,
          );

          final readinessCard = _LobbyReadinessCard(state: state);
          final backendCard = _BackendTargetCard(target: backendTarget);

          final controlsCard = AppCard(
            glowColor: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.isHostMode ? 'Host room setup' : 'Guest join setup',
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  state.isHostMode
                      ? 'Keep host identity and room generation separate from backend concerns now so the repository can later swap to a live service with minimal presentation churn.'
                      : 'Keep guest identity and join-code validation readable now so a future backend can focus on actual room membership and syncing instead of input cleanup.',
                  style: AppTextStyles.subtitle.copyWith(height: 1.45),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _playerNameController,
                  textInputAction: state.isHostMode
                      ? TextInputAction.done
                      : TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: state.isHostMode
                        ? 'Host player name'
                        : 'Guest player name',
                    helperText: state.isHostMode
                        ? 'Used as the room owner inside the mock online lobby preview.'
                        : 'Used as the joining player inside the mock online lobby preview.',
                  ),
                  onChanged: controller.updatePlayerName,
                ),
                if (state.isJoinMode) ...[
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _joinCodeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Join code',
                      helperText:
                          'Codes are normalized to uppercase and trimmed to six characters.',
                    ),
                    onChanged: controller.updateJoinCode,
                  ),
                ] else ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.14),
                      ),
                    ),
                    child: Text(
                      state.activeSession == null
                          ? 'Create a mock room to generate the first shareable code for the host flow.'
                          : 'Your latest generated room code remains staged below and can be copied from the session preview card.',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: state.isHostMode
                      ? usesFirebaseBackend
                          ? 'Create Firebase Room'
                          : 'Create Mock Room'
                      : usesFirebaseBackend
                          ? 'Join Firebase Room'
                          : 'Preview Join',
                  icon: state.isHostMode
                      ? Icons.add_home_work_outlined
                      : Icons.login_rounded,
                  onPressed: state.isHostMode
                      ? state.canCreateRoom
                          ? usesFirebaseBackend
                              ? () => _runAsyncAction(
                                    () => controller.createRoomRealtime(),
                                    successMessage:
                                        'Firebase room created. Live room watching is now bound to this session.',
                                  )
                              : () => _runAction(
                                    () => controller.createRoomPreview(),
                                    successMessage:
                                        'Mock host room created. Realtime syncing comes later.',
                                  )
                          : null
                      : state.canJoinRoom
                          ? usesFirebaseBackend
                              ? () => _runAsyncAction(
                                    () => controller.joinRoomRealtime(),
                                    successMessage:
                                        'Firebase room joined. Live room watching is now bound to this session.',
                                  )
                              : () => _runAction(
                                    () => controller.joinRoomPreview(),
                                    successMessage:
                                        'Join preview completed. This is still a local mock lobby state.',
                                  )
                          : null,
                ),
              ],
            ),
          );

          final sessionCard = state.activeSession == null
              ? _EmptySessionCard(
                  mode: state.lobbyMode,
                  joinCode: state.joinCode,
                )
              : _RoomSessionCard(
                  session: state.activeSession!,
                  canSimulateRemoteGuestJoin:
                      supportsMockSimulation && state.canSimulateRemoteGuestJoin,
                  canSimulateRemoteReadyToggle:
                      supportsMockSimulation && state.canSimulateRemoteReadyToggle,
                  onClear: controller.clearSession,
                  onCopyRoomCode: () =>
                      _copyRoomCode(state.activeSession!.roomCode),
                  onToggleReady: usesFirebaseBackend
                      ? _toggleLocalReadyRealtime
                      : _toggleLocalReady,
                  onSimulateRemoteGuestJoin: _simulateRemoteGuestJoin,
                  onToggleRemoteReady: _toggleRemoteReady,
                );

          final nextStepsCard = AppCard(
            glowColor: AppColors.accent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Next online milestones',
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: AppSpacing.sm),
                _NextStepRow(
                  title: 'Replace mock repository with a realtime backend',
                  subtitle:
                      'The controller already depends on an interface, so Firebase or Supabase can later slot in behind the same lobby flow.',
                ),
                const SizedBox(height: AppSpacing.md),
                _NextStepRow(
                  title: 'Sync remote match state and room membership',
                  subtitle:
                      'Room host, guest, and readiness should later move from preview-only state into a shared online session source of truth.',
                ),
                const SizedBox(height: AppSpacing.md),
                _NextStepRow(
                  title: 'Bridge online lobby into the existing match engine',
                  subtitle:
                      'Official no-lives rules, trait secrecy, and shared-pool resolution should still remain inside the existing game-domain layer.',
                ),
              ],
            ),
          );

          if (useWideLayout) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  heroCard,
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            modeCard,
                            const SizedBox(height: AppSpacing.md),
                            backendCard,
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(flex: 8, child: readinessCard),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 11,
                        child: Column(
                          children: [
                            controlsCard,
                            const SizedBox(height: AppSpacing.md),
                            const OnlineBootstrapPreviewCard(),
                            const SizedBox(height: AppSpacing.md),
                            nextStepsCard,
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(flex: 9, child: sessionCard),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          }

          return ListView(
            children: [
              heroCard,
              const SizedBox(height: AppSpacing.md),
              modeCard,
              const SizedBox(height: AppSpacing.md),
              backendCard,
              const SizedBox(height: AppSpacing.md),
              readinessCard,
              const SizedBox(height: AppSpacing.md),
              controlsCard,
              const SizedBox(height: AppSpacing.md),
              sessionCard,
              const SizedBox(height: AppSpacing.md),
              const OnlineBootstrapPreviewCard(),
              const SizedBox(height: AppSpacing.md),
              nextStepsCard,
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Future<void> _copyRoomCode(String roomCode) async {
    await Clipboard.setData(ClipboardData(text: roomCode));
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Room code $roomCode copied.')),
    );
  }

  void _toggleLocalReady() {
    try {
      final session =
          ref.read(onlineLobbyControllerProvider.notifier).toggleLocalReady();
      if (!mounted) {
        return;
      }

      final readinessLabel = session.localParticipant.isReady
          ? 'marked ready'
          : 'marked not ready';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${session.localParticipant.displayName} is now $readinessLabel.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error')),
      );
    }
  }

  void _toggleLocalReadyRealtime() {
    _runAsyncAction(
      () => ref
          .read(onlineLobbyControllerProvider.notifier)
          .toggleLocalReadyRealtime(),
      successMessage: 'Firebase ready state updated for the local participant.',
      successBuilder: (session) {
        final readinessLabel = session.localParticipant.isReady
            ? 'marked ready'
            : 'marked not ready';
        return '${session.localParticipant.displayName} is now $readinessLabel.';
      },
    );
  }

  void _simulateRemoteGuestJoin() {
    try {
      final session = ref
          .read(onlineLobbyControllerProvider.notifier)
          .simulateRemoteGuestJoin();
      if (!mounted) {
        return;
      }

      final remoteGuestName = session.guestPlayerName ?? 'Remote Guest';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$remoteGuestName joined the mock room preview.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error')),
      );
    }
  }

  void _toggleRemoteReady() {
    try {
      final session =
          ref.read(onlineLobbyControllerProvider.notifier).toggleRemoteReady();
      if (!mounted) {
        return;
      }

      final remoteParticipant = session.primaryRemoteParticipant;
      final readinessLabel = remoteParticipant?.isReady == true
          ? 'marked ready'
          : 'marked not ready';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${remoteParticipant?.displayName ?? 'Remote participant'} is now $readinessLabel.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error')),
      );
    }
  }

  Future<void> _runAsyncAction(
    Future<OnlineRoomSession> Function() action, {
    required String successMessage,
    String Function(OnlineRoomSession session)? successBuilder,
  }) async {
    try {
      final session = await action();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successBuilder?.call(session) ?? successMessage),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error')),
      );
    }
  }

  void _runAction(
    OnlineRoomSession Function() action, {
    required String successMessage,
  }) {
    try {
      action();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error')),
      );
    }
  }
}

class _LobbyModeCard extends StatelessWidget {
  const _LobbyModeCard({
    required this.selectedMode,
    required this.onModeSelected,
  });

  final OnlineLobbyMode selectedMode;
  final ValueChanged<OnlineLobbyMode> onModeSelected;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      glowColor: AppColors.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lobby path', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Choose whether this device is previewing the host flow or the guest join flow.',
            style: AppTextStyles.subtitle.copyWith(height: 1.45),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ChoiceChip(
                label: const Text('Host Room'),
                selected: selectedMode == OnlineLobbyMode.host,
                onSelected: (_) => onModeSelected(OnlineLobbyMode.host),
              ),
              ChoiceChip(
                label: const Text('Join Room'),
                selected: selectedMode == OnlineLobbyMode.join,
                onSelected: (_) => onModeSelected(OnlineLobbyMode.join),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackendTargetCard extends StatelessWidget {
  const _BackendTargetCard({required this.target});

  final OnlineBackendTarget target;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      glowColor: AppColors.success,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Backend boundary', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'The online lobby now resolves through a datasource boundary so backend work can grow behind the same repository without touching game-rule ownership.',
            style: AppTextStyles.subtitle.copyWith(height: 1.45),
          ),
          const SizedBox(height: AppSpacing.md),
          AppBadge(
            icon: Icons.storage_rounded,
            label: target.label,
            accent: AppColors.success,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            target.description,
            style: AppTextStyles.body.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _LobbyReadinessCard extends StatelessWidget {
  const _LobbyReadinessCard({required this.state});

  final OnlineLobbyState state;

  @override
  Widget build(BuildContext context) {
    final isReady = state.isHostMode ? state.canCreateRoom : state.canJoinRoom;

    return AppCard(
      glowColor: isReady ? AppColors.success : AppColors.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  state.isHostMode ? 'Host readiness' : 'Guest readiness',
                  style: AppTextStyles.title,
                ),
              ),
              AppBadge(
                icon: isReady
                    ? Icons.check_circle_outline
                    : Icons.schedule_outlined,
                label: isReady ? 'Ready' : 'Needs input',
                accent: isReady ? AppColors.success : AppColors.accent,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            state.isHostMode
                ? 'Generate a mock room after confirming the host name. The resulting code can then be copied and shared in a later backend-backed flow.'
                : 'Enter a player name and a six-character code to preview the guest-side join summary before realtime syncing exists.',
            style: AppTextStyles.subtitle.copyWith(height: 1.45),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppBadge(
                icon: Icons.person_outline,
                label: state.playerName.isEmpty
                    ? 'Name pending'
                    : 'Player: ${state.playerName}',
                accent: AppColors.secondary,
              ),
              if (state.isJoinMode)
                AppBadge(
                  icon: Icons.key_outlined,
                  label: state.joinCode.isEmpty
                      ? 'Code pending'
                      : 'Code: ${_formatRoomCode(state.joinCode)}',
                  accent: AppColors.primary,
                ),
              if (state.activeSession != null)
                AppBadge(
                  icon: state.activeSession!.localParticipant.isReady
                      ? Icons.check_circle_outline
                      : Icons.radio_button_unchecked_outlined,
                  label: state.activeSession!.localParticipant.isReady
                      ? 'Local player ready'
                      : 'Local player not ready',
                  accent: state.activeSession!.localParticipant.isReady
                      ? AppColors.success
                      : AppColors.accent,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptySessionCard extends StatelessWidget {
  const _EmptySessionCard({
    required this.mode,
    required this.joinCode,
  });

  final OnlineLobbyMode mode;
  final String joinCode;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Room preview', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Text(
            mode == OnlineLobbyMode.host
                ? 'No host session has been previewed yet. Create a mock room to generate a shareable code and inspect the waiting-for-opponent state.'
                : joinCode.isEmpty
                    ? 'No guest session has been previewed yet. Enter a six-character code to inspect how the join-side lobby summary will look before realtime networking is added.'
                    : 'Join code ${_formatRoomCode(joinCode)} is staged. Preview joining to inspect how the online lobby summary will look before realtime networking is added.',
            style: AppTextStyles.subtitle.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _RoomSessionCard extends StatelessWidget {
  const _RoomSessionCard({
    required this.session,
    required this.canSimulateRemoteGuestJoin,
    required this.canSimulateRemoteReadyToggle,
    required this.onClear,
    required this.onCopyRoomCode,
    required this.onToggleReady,
    required this.onSimulateRemoteGuestJoin,
    required this.onToggleRemoteReady,
  });

  final OnlineRoomSession session;
  final bool canSimulateRemoteGuestJoin;
  final bool canSimulateRemoteReadyToggle;
  final VoidCallback onClear;
  final VoidCallback onCopyRoomCode;
  final VoidCallback onToggleReady;
  final VoidCallback onSimulateRemoteGuestJoin;
  final VoidCallback onToggleRemoteReady;

  @override
  Widget build(BuildContext context) {
    final accent = session.isHost ? AppColors.secondary : AppColors.accent;
    final localParticipant = session.localParticipant;

    return AppSummaryCard(
      title: 'Active room preview',
      description: _phaseDescription(session),
      glowColor: accent,
      rowBackgroundColor: accent.withValues(alpha: 0.08),
      items: [
        AppSummaryItem(
          label: 'Local role',
          value: session.isHost ? 'Host' : 'Guest',
        ),
        AppSummaryItem(label: 'Room code', value: session.roomCode),
        AppSummaryItem(label: 'Phase', value: _phaseLabel(session.phase)),
        AppSummaryItem(
          label: 'Participants',
          value: '${session.participantCount}/2',
        ),
        AppSummaryItem(
          label: 'Local readiness',
          value: localParticipant.isReady ? 'Ready' : 'Not ready',
        ),
      ],
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: accent.withValues(alpha: 0.16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shareable room code',
                  style: AppTextStyles.label.copyWith(color: accent),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _formatRoomCode(session.roomCode),
                  style: AppTextStyles.hero.copyWith(fontSize: 30),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  session.isHost
                      ? 'Copy this code for the future guest join flow.'
                      : 'This normalized code is the guest-side room target for the future realtime lobby.',
                  style: AppTextStyles.subtitle.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('Lobby participants', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Column(
            children: session.participants
                .map(
                  (participant) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ParticipantStatusTile(participant: participant),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: localParticipant.isReady
                      ? 'Mark Not Ready'
                      : 'Mark Ready',
                  icon: localParticipant.isReady
                      ? Icons.pause_circle_outline
                      : Icons.check_circle_outline,
                  onPressed: onToggleReady,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  label: 'Copy Code',
                  icon: Icons.copy_rounded,
                  isPrimary: false,
                  onPressed: onCopyRoomCode,
                ),
              ),
            ],
          ),
          if (canSimulateRemoteGuestJoin || canSimulateRemoteReadyToggle) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.14),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mock remote event controls',
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Use these preview-only controls to mimic a second device joining the room or changing remote readiness before realtime backend syncing exists.',
                    style: AppTextStyles.subtitle.copyWith(height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (canSimulateRemoteGuestJoin)
                    AppButton(
                      label: 'Simulate Remote Guest Join',
                      icon: Icons.person_add_alt_1_rounded,
                      isPrimary: false,
                      onPressed: onSimulateRemoteGuestJoin,
                    ),
                  if (canSimulateRemoteGuestJoin && canSimulateRemoteReadyToggle)
                    const SizedBox(height: AppSpacing.sm),
                  if (canSimulateRemoteReadyToggle)
                    AppButton(
                      label: session.primaryRemoteParticipant?.isReady == true
                          ? 'Simulate Remote Not Ready'
                          : 'Simulate Remote Ready',
                      icon: session.primaryRemoteParticipant?.isReady == true
                          ? Icons.pause_circle_outline
                          : Icons.cloud_done_outlined,
                      isPrimary: false,
                      onPressed: onToggleRemoteReady,
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Clear Preview',
            icon: Icons.refresh_rounded,
            isPrimary: false,
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}

class _ParticipantStatusTile extends StatelessWidget {
  const _ParticipantStatusTile({required this.participant});

  final OnlineRoomParticipant participant;

  @override
  Widget build(BuildContext context) {
    final accent = participant.isReady ? AppColors.success : AppColors.accent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  participant.displayName,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              AppBadge(
                label: participant.role == OnlineRoomParticipantRole.host
                    ? 'HOST'
                    : 'GUEST',
                accent: AppColors.secondary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppBadge(
                icon: participant.isLocalPlayer
                    ? Icons.phone_android_outlined
                    : Icons.cloud_outlined,
                label: participant.isLocalPlayer
                    ? 'Local preview'
                    : 'Remote preview',
                accent: AppColors.primary,
              ),
              AppBadge(
                icon: _connectionIcon(participant.connectionState),
                label: _connectionLabel(participant.connectionState),
                accent: AppColors.secondary,
              ),
              AppBadge(
                icon: participant.isReady
                    ? Icons.check_circle_outline
                    : Icons.radio_button_unchecked_outlined,
                label: participant.isReady ? 'Ready' : 'Not ready',
                accent: accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextStepRow extends StatelessWidget {
  const _NextStepRow({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Icon(
            Icons.arrow_forward_rounded,
            size: 14,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.subtitle.copyWith(height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _phaseLabel(OnlineRoomPhase phase) {
  switch (phase) {
    case OnlineRoomPhase.waitingForOpponent:
      return 'Waiting for opponent';
    case OnlineRoomPhase.waitingForReady:
      return 'Waiting for ready';
    case OnlineRoomPhase.readyToSync:
      return 'Ready to sync';
  }
}

String _phaseDescription(OnlineRoomSession session) {
  switch (session.phase) {
    case OnlineRoomPhase.waitingForOpponent:
      return 'This room is waiting for a second participant before remote syncing can begin.';
    case OnlineRoomPhase.waitingForReady:
      return 'Both participant slots exist in preview form, but at least one side still needs to mark ready before sync handoff.';
    case OnlineRoomPhase.readyToSync:
      return 'Every participant in the preview lobby is marked ready, so the session shape is prepared for a future realtime handoff.';
  }
}

IconData _connectionIcon(OnlineRoomParticipantConnectionState state) {
  switch (state) {
    case OnlineRoomParticipantConnectionState.localPreview:
      return Icons.smartphone_outlined;
    case OnlineRoomParticipantConnectionState.waitingRemote:
      return Icons.hourglass_top_rounded;
    case OnlineRoomParticipantConnectionState.connected:
      return Icons.cloud_done_outlined;
  }
}

String _connectionLabel(OnlineRoomParticipantConnectionState state) {
  switch (state) {
    case OnlineRoomParticipantConnectionState.localPreview:
      return 'Local preview';
    case OnlineRoomParticipantConnectionState.waitingRemote:
      return 'Waiting remote';
    case OnlineRoomParticipantConnectionState.connected:
      return 'Connected preview';
  }
}

String _formatRoomCode(String value) {
  final trimmed = value.trim();
  if (trimmed.length <= 3) {
    return trimmed;
  }

  return '${trimmed.substring(0, 3)} ${trimmed.substring(3)}';
}
