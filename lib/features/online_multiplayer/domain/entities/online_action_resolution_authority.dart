enum OnlineActionResolutionAuthority {
  hostClient,
  manualDebugClient,
  backendService,
}

extension OnlineActionResolutionAuthorityX on OnlineActionResolutionAuthority {
  String get label {
    switch (this) {
      case OnlineActionResolutionAuthority.hostClient:
        return 'Host client resolves actions';
      case OnlineActionResolutionAuthority.manualDebugClient:
        return 'Manual debug resolver';
      case OnlineActionResolutionAuthority.backendService:
        return 'Backend authority resolves actions';
    }
  }

  String get description {
    switch (this) {
      case OnlineActionResolutionAuthority.hostClient:
        return 'For the current online foundation, the host device is the temporary official resolver for queued actions.';
      case OnlineActionResolutionAuthority.manualDebugClient:
        return 'Queued actions are only resolved through an explicit local debug/manual trigger.';
      case OnlineActionResolutionAuthority.backendService:
        return 'Queued actions are resolved through the dedicated backend-authority path instead of a local widget-driven resolver trigger.';
    }
  }
}
