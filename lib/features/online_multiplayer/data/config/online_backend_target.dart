enum OnlineBackendTarget {
  mockPreview,
  firebasePreview,
  firebaseBackend,
  supabasePreview,
}

extension OnlineBackendTargetX on OnlineBackendTarget {
  String get label {
    switch (this) {
      case OnlineBackendTarget.mockPreview:
        return 'Mock Preview';
      case OnlineBackendTarget.firebasePreview:
        return 'Firebase Preview Adapter';
      case OnlineBackendTarget.firebaseBackend:
        return 'Firebase Backend';
      case OnlineBackendTarget.supabasePreview:
        return 'Supabase Preview Adapter';
    }
  }

  String get description {
    switch (this) {
      case OnlineBackendTarget.mockPreview:
        return 'Runs the local preview lobby directly with no backend dependency.';
      case OnlineBackendTarget.firebasePreview:
        return 'Keeps the same local preview behavior while reserving a Firebase-shaped datasource boundary for future realtime work.';
      case OnlineBackendTarget.firebaseBackend:
        return 'Uses Firebase Auth and Cloud Firestore for real room creation, join, ready updates, and room watching when runtime configuration is available.';
      case OnlineBackendTarget.supabasePreview:
        return 'Keeps the same local preview behavior while reserving a Supabase-shaped datasource boundary for future realtime work.';
    }
  }
}
