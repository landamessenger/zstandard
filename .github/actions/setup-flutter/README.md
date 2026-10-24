# Flutter on shared runners

The composite installs the requested stable SDK for the runner architecture in
the versioned `zstandard-flutter-v2` tool cache. Linux jobs use the `vypdev` group
with `self-hosted, codex, Linux`; Apple jobs use `self-hosted, macOS, ARM64`.
Windows jobs use the separate `setup-flutter-windows` action, which selects Git
Bash and verifies its downloaded jq executable.

On Unix, subsequent `flutter` commands use a job-owned settings profile through
a private launcher. SwiftPM/CocoaPods selection therefore cannot overwrite the
operator's Flutter settings or another runner's selection. The existing pub
cache remains explicit; SDK files, the parent HOME and global Git configuration
are not replaced. Standalone `dart` publishing keeps its workflow-owned
credential configuration.

Apple integration tests require Xcode and an installed iOS runtime. CI creates
and removes only its own simulator UUID. Setup does not install Xcode or accept
Apple agreements. The reconciliation keeps develop's existing test matrices,
coverage thresholds and complete package publication workflow.
