# Codex and Select for Figma

Configure `system.programs.codex` / `users.<name>.programs.codex`, or the
corresponding `select-for-figma` path. Both `enable` switches default to false.

Every preference defaults to null and preserves the existing live value. Selected
fields are reapplied on rebuild; removing a selection leaves the last live value.
Configuration remains writable. Close Select before applying selected preferences;
activation checks both the native and legacy application names on the session bus.
Restart other running apps after changing preferences.
Named records preserve fields and entries you have not selected. Store credentials
in the app or keyring; environment-variable options name secrets without copying
them into the public Nix store. Codex TOML comments and both apps’ runtime state
are preserved. Changed files have a private `.zenos-backup` beside them.

Codex follows CODEX_HOME (default ~/.codex); stateDirectory also sets CODEX_HOME.
Native Select for Figma v1.0.2 follows XDG_DATA_HOME/select-for-figma/state.json
(default ~/.local/share/select-for-figma/state.json).
Activation uses the environment of the user activation service. Immutable config
symlinks require migration to writable files before selecting preferences.

Sources: [Codex reference](https://learn.chatgpt.com/docs/config-file/config-reference),
[Codex 0.159.0 schema](https://github.com/openai/codex/blob/rust-v0.159.0/codex-rs/core/config.schema.json),
[Select for Figma v1.0.2](https://github.com/doromiert/select-for-figma/tree/v1.0.2).

```zcfg
users.alex.programs.codex = {
  enable = true;
  reasoningEffort = "high";
  commandApproval = "ask-when-needed";
  fileAccess = "workspace";
  terminal.animations = false;
  providers.local = { apiUrl = "http://localhost:11434/v1"; displayName = "Local model server"; };
  toolServers.docs = { serverUrl = "https://developers.openai.com/mcp"; };
};
users.alex.programs.select-for-figma = {
  enable = true;
  restoreOpenFiles = true;
  appearance = "system";
  adwaitaEditorTheme = true;
  tabSwitchingOrder = "recent";
  localFonts = true;
  notifications = true;
  downloadDirectory = "/home/alex/Downloads";
  zane.chat.reasoningEffort = "";
  zane.showAccountPresence = false;
  zane.automaticEditAccess = false;
};
```

## codex

| Option | Backend field | Details |
| --- | --- | --- |
| `model` | `model` |  |
| `reviewModel` | `review_model` |  |
| `reasoningEffort` | `model_reasoning_effort` |  |
| `planningReasoningEffort` | `plan_mode_reasoning_effort` |  |
| `responsePriority` | `service_tier` |  |
| `modelProvider` | `model_provider` |  |
| `instructionFile` | `model_instructions_file` |  |
| `extraInstructions` | `developer_instructions` |  |
| `logDirectory` | `log_dir` |  |
| `reasoningSummary` | `model_reasoning_summary` |  |
| `answerDetail` | `model_verbosity` |  |
| `localModelServer` | `oss_provider` |  |
| `contextWindowTokens` | `model_context_window` |  |
| `compactAfterTokens` | `model_auto_compact_token_limit` |  |
| `compactAfterReplyPercent` | `model_post_turn_compact_threshold_percent` |  |
| `instructionLimitBytes` | `project_doc_max_bytes` |  |
| `tools.outputLimitTokens` | `tool_output_token_limit` |  |
| `tools.backgroundPollLimitMilliseconds` | `background_terminal_max_timeout` |  |
| `tools.optionalServerWaitMilliseconds` | `mcp_optional_startup_grace_ms` |  |
| `historyLimitBytes` | `history.max_bytes` |  |
| `commandApproval` | `approval_policy` |  |
| `fileAccess` | `sandbox_mode` |  |
| `commandNetworkAccess` | `sandbox_workspace_write.network_access` | Applies to commands in workspace file-access mode. |
| `workspace.extraWritableDirectories` | `sandbox_workspace_write.writable_roots` |  |
| `workspace.writeSystemTemporaryFiles` | `sandbox_workspace_write.exclude_slash_tmp` |  |
| `workspace.writeSessionTemporaryFiles` | `sandbox_workspace_write.exclude_tmpdir_env_var` |  |
| `credentialStorage` | `cli_auth_credentials_store` |  |
| `loginMethod` | `forced_login_method` |  |
| `loginWorkspaces` | `forced_chatgpt_workspace_id` |  |
| `storeHistory` | `history.persistence` |  |
| `notificationCommand` | `notify` |  |
| `sendUsageStatistics` | `analytics.enabled` |  |
| `allowFeedback` | `feedback.enabled` |  |
| `checkForUpdates` | `check_for_update_on_startup` |  |
| `environment.loginShells` | `allow_login_shell` |  |
| `environment.keepCredentialVariables` | `shell_environment_policy.ignore_default_excludes` |  |
| `agents.enable` | `agents.enabled` |  |
| `agents.reportInterruptions` | `agents.interrupt_message` |  |
| `memories.createFromConversations` | `memories.generate_memories` |  |
| `memories.useForAnswers` | `memories.use_memories` |  |
| `browser.allowHistoryAccess` | `browser_use.allow_history_access` |  |
| `skills.includeInstructions` | `skills.include_instructions` |  |
| `instructionFallbackNames` | `project_doc_fallback_filenames` | Fallback instruction filenames when the normal AGENTS files are absent. |
| `projectRootMarkers` | `project_root_markers` |  |
| `environment.inherit` | `shell_environment_policy.inherit` |  |
| `environment.variables` | `shell_environment_policy.set` | Values are generated into the Nix store; use this for non-secret environment variables. |
| `environment.excludeNames` | `shell_environment_policy.exclude` | Regular expressions for inherited environment variable names to exclude. |
| `environment.includeNames` | `shell_environment_policy.include_only` | Regular expressions limiting inherited environment variable names. |
| `agents.defaultModel` | `agents.default_subagent_model` |  |
| `agents.reasoningEffort` | `agents.default_subagent_reasoning_effort` |  |
| `agents.maximumConcurrentAgents` | `agents.max_concurrent_threads_per_session` |  |
| `agents.maximumDepth` | `agents.max_depth` | Applies to the original agent engine; the newer engine ignores this setting. |
| `memories.conversationSummaryModel` | `memories.extract_model` |  |
| `memories.consolidationModel` | `memories.consolidation_model` |  |
| `memories.maximumConversationAgeDays` | `memories.max_rollout_age_days` |  |
| `memories.minimumIdleHours` | `memories.min_rollout_idle_hours` |  |
| `memories.minimumRemainingUsagePercent` | `memories.min_rate_limit_remaining_percent` |  |
| `memories.maximumConversationsPerPass` | `memories.max_rollouts_per_startup` |  |
| `memories.maximumUnusedDays` | `memories.max_unused_days` |  |
| `skills.instructionLimitTokens` | `skills.max_context_tokens` |  |
| `terminal.animations` | `tui.animations` |  |
| `terminal.fullscreenTranscript` | `tui.fullscreen_transcript` |  |
| `terminal.rawScrollback` | `tui.raw_output_mode` |  |
| `terminal.automaticRecaps` | `tui.auto_recap` |  |
| `terminal.startupHints` | `tui.show_tooltips` |  |
| `terminal.startInVimMode` | `tui.vim_mode_default` |  |
| `terminal.colorStatusItems` | `tui.status_line_use_colors` |  |
| `terminal.renderTables` | `tui.rendering.tables` |  |
| `terminal.renderMath` | `tui.rendering.math` |  |
| `terminal.renderDiagrams` | `tui.rendering.mermaid` |  |
| `terminal.renderLists` | `tui.rendering.lists` |  |
| `terminal.syntaxTheme` | `tui.theme` |  |
| `terminal.alternateScreen` | `tui.alternate_screen` |  |
| `terminal.copySelection` | `tui.copy_on_select` |  |
| `terminal.rightClickPaste` | `tui.right_click_paste` |  |
| `terminal.groupPastedText` | `tui.disable_paste_burst` |  |
| `terminal.notifications` | `tui.notifications` | True enables all events, false disables them, or supply event names to select notifications. |
| `terminal.notifyWhen` | `tui.notification_condition` |  |
| `terminal.notificationDelivery` | `tui.notification_method` |  |
| `terminal.statusItems` | `tui.status_line` |  |
| `terminal.titleItems` | `tui.terminal_title` |  |
| `terminal.resumeDirectory` | `tui.resume_cwd` |  |
| `terminal.sessionListDensity` | `tui.session_picker_view` |  |
| `terminal.showReasoningSummaries` | `hide_agent_reasoning` |  |
| `terminal.showUnfilteredReasoning` | `show_raw_agent_reasoning` |  |
| `terminal.resizeHistoryLines` | `tui.terminal_resize_reflow_max_rows` |  |
| `webSearch` | `web_search` |  |
| `fileLinksOpenIn` | `file_opener` |  |
| `toolCredentialStorage` | `mcp_oauth_credentials_store` |  |
| `toolLoginCallbackPort` | `mcp_oauth_callback_port` |  |
| `toolLoginCallbackUrl` | `mcp_oauth_callback_url` |  |
| `defaultProfile` | `profile` |  |
| `stateDirectory` | CODEX_HOME | Absolute settings, login and session directory. |
| `providers.<name>.displayName` | `model_providers.<name>.name` | Selected fields only. |
| `providers.<name>.apiUrl` | `model_providers.<name>.base_url` | Selected fields only. |
| `providers.<name>.apiKeyVariable` | `model_providers.<name>.env_key` | Selected fields only. |
| `providers.<name>.apiKeyHelp` | `model_providers.<name>.env_key_instructions` | Selected fields only. |
| `providers.<name>.headerVariables` | `model_providers.<name>.env_http_headers` | Selected fields only. |
| `providers.<name>.queryParameters` | `model_providers.<name>.query_params` | Selected fields only. |
| `providers.<name>.useOpenAiLogin` | `model_providers.<name>.requires_openai_auth` | Selected fields only. |
| `providers.<name>.websocketTransport` | `model_providers.<name>.supports_websockets` | Selected fields only. |
| `providers.<name>.requestRetryLimit` | `model_providers.<name>.request_max_retries` | Selected fields only. |
| `providers.<name>.streamRetryLimit` | `model_providers.<name>.stream_max_retries` | Selected fields only. |
| `providers.<name>.streamIdleTimeoutMilliseconds` | `model_providers.<name>.stream_idle_timeout_ms` | Selected fields only. |
| `providers.<name>.connectionTimeoutMilliseconds` | `model_providers.<name>.websocket_connect_timeout_ms` | Selected fields only. |
| `toolServers.<name>.enable` | `mcp_servers.<name>.enabled` | Selected fields only. |
| `toolServers.<name>.requiredForStartup` | `mcp_servers.<name>.required` | Selected fields only. |
| `toolServers.<name>.command` | `mcp_servers.<name>.command` | Selected fields only. |
| `toolServers.<name>.arguments` | `mcp_servers.<name>.args` | Selected fields only. |
| `toolServers.<name>.workingDirectory` | `mcp_servers.<name>.cwd` | Selected fields only. |
| `toolServers.<name>.serverUrl` | `mcp_servers.<name>.url` | Selected fields only. |
| `toolServers.<name>.bearerTokenVariable` | `mcp_servers.<name>.bearer_token_env_var` | Selected fields only. |
| `toolServers.<name>.environmentVariables` | `mcp_servers.<name>.env` | Selected fields only. |
| `toolServers.<name>.inheritedVariables` | `mcp_servers.<name>.env_vars` | Selected fields only. |
| `toolServers.<name>.headerVariables` | `mcp_servers.<name>.env_http_headers` | Selected fields only. |
| `toolServers.<name>.allowedTools` | `mcp_servers.<name>.enabled_tools` | Selected fields only. |
| `toolServers.<name>.blockedTools` | `mcp_servers.<name>.disabled_tools` | Selected fields only. |
| `toolServers.<name>.startupTimeoutSeconds` | `mcp_servers.<name>.startup_timeout_sec` | Selected fields only. |
| `toolServers.<name>.toolTimeoutSeconds` | `mcp_servers.<name>.tool_timeout_sec` | Selected fields only. |
| `toolServers.<name>.parallelToolCalls` | `mcp_servers.<name>.supports_parallel_tool_calls` | Selected fields only. |
| `toolServers.<name>.loginScopes` | `mcp_servers.<name>.scopes` | Selected fields only. |
| `profiles.<name>.model` | `profiles.<name>.model` | Selected fields only. |
| `profiles.<name>.modelProvider` | `profiles.<name>.model_provider` | Selected fields only. |
| `profiles.<name>.reasoningEffort` | `profiles.<name>.model_reasoning_effort` | Selected fields only. |
| `profiles.<name>.planningReasoningEffort` | `profiles.<name>.plan_mode_reasoning_effort` | Selected fields only. |
| `profiles.<name>.answerDetail` | `profiles.<name>.model_verbosity` | Selected fields only. |
| `profiles.<name>.responsePriority` | `profiles.<name>.service_tier` | Selected fields only. |
| `profiles.<name>.webSearch` | `profiles.<name>.web_search` | Selected fields only. |
| `profiles.<name>.instructionFile` | `profiles.<name>.model_instructions_file` | Selected fields only. |
| `agentRoles.<name>.purpose` | `agents.<name>.description` | Selected fields only. |
| `agentRoles.<name>.configurationFile` | `agents.<name>.config_file` | Selected fields only. |

## select-for-figma

These options target native GTK/libadwaita Select for Figma v1.0.2, not the
older Electron Figma Linux application. Every option below defaults to null
(no write); the defaults in the table are upstream defaults, not module defaults.
Backend keys are flat JSON members of `state.json`.

| Option | Backend field | Type, upstream default, and validation |
| --- | --- | --- |
| `appearance` | `appearance` | Nullable enum `system`, `light`, `dark`; upstream `system`. |
| `adwaitaEditorTheme` | `adwaita-editor` | Nullable boolean; upstream true. GNOME styling for Figma homepage, panels, and controls. |
| `restoreOpenFiles` | `restore-session` | Nullable boolean; upstream true. |
| `tabSwitchingOrder` | `tab-switcher-mru` | Nullable enum `position`, `recent`; lowers to false/true respectively. Upstream `position`. |
| `localFonts` | `local-fonts` | Nullable boolean; upstream true. Makes installed fonts available to Figma. |
| `notifications` | `notifications` | Nullable boolean; upstream true. Figma notifications and background download alerts. |
| `downloadDirectory` | `download-folder` | Nullable string; require an absolute path. Upstream uses the user's XDG Downloads directory, falling back to home. The app itself accepts a string without path validation and updates this preference after downloads. |
| `zane.chat.model` | `zane-chat-model` | Nullable string, at most 200 UTF-8 bytes; upstream empty string inherits Codex settings. |
| `zane.chat.reasoningEffort` | `zane-chat-effort` | Nullable string, at most 32 UTF-8 bytes; upstream empty string inherits. Use values supported by the selected model. |
| `zane.work.model` | `zane-work-model` | Nullable string, at most 200 UTF-8 bytes; upstream empty string inherits Codex settings. |
| `zane.work.reasoningEffort` | `zane-work-effort` | Nullable string, at most 32 UTF-8 bytes; upstream empty string inherits. Use values supported by the selected model. |
| `zane.showAccountPresence` | `zane-account-presence` | Nullable boolean; upstream false. Uses Zane's separate signed-in Figma account, visible to collaborators; this preference does not establish a login. |
| `zane.automaticEditAccess` | `zane-auto-edit-access` | Nullable boolean; upstream true. Automatically invites Zane's signed-in account to the current file; paid-plan seat changes retain Figma's approval flow. |

Reasoning efforts are model-dependent strings returned by Codex `model/list`
(`supportedReasoningEfforts[].reasoningEffort`), not a closed enum. Null leaves
the current choice untouched; an explicit empty string selects inheritance.
The native loader clears model strings longer than 200 bytes and effort strings
longer than 32 bytes; declarations should reject these rather than silently reset.

The Electron-only options `showCreateFileButton`, `useSystemFileDialogs`,
`forceStandardRgb`, `customThemes`, `theme`, `exportDirectory`,
`fontSearchDirectories`, `browserArguments`, `tabBarHeightPixels`, `tabBarScale`,
`canvasInterfaceScale`, `logging`, and `themeEditor.legacyPreview` are removed.
`restoreOpenFiles` remains but now writes `restore-session`, not
`app.saveLastOpenedTabs`. No Electron settings file is read or migrated.

Apply only selected flat keys to a writable, user-owned JSON object, preserving
unselected members. Use private backups and atomic replacement (directory mode
0700, file mode 0600); reject malformed JSON and immutable store files without
changing them. With no selected preferences, perform no write or migration.

Before the first activation write, mirror the native whole-directory migration:
if the destination `XDG_DATA_HOME/select-for-figma` does not exist (including a
symlink) and `XDG_DATA_HOME/figma-gtk` is a directory, rename the entire legacy
directory to the destination. Do not create the destination first: doing so
suppresses upstream migration and strands Chromium profiles and session data.
If the destination already exists, leave both directories intact. A failed
required rename must stop the update without replacing legacy state.

Apply while Select and any legacy FigmaGtk instance are closed; defer or fail
with an actionable message when running, and do not terminate them implicitly.
The app loads state into memory and rewrites the complete file on preference
changes, session persistence, and shutdown. Atomic replacement alone cannot
prevent a running instance from overwriting activation changes. Restart to load
applied preferences; there is no external live-settings reload contract.

Do not declare window geometry, tabs, groups, recents, export history, Chromium
profiles/cookies, `keepassxc-paired`, tokens, or keyring associations as program
preferences. Keep authentication in the app/keyring and preserve runtime state.

Source evidence is the local `select-for-figma` repository at tag `v1.0.2`
(commit `6d0444148334e169ca4a8ab78744f0d8be2e8932`): `src/state.hpp` defines
initial defaults; `src/state.cpp:51` implements migration, `:57` resolves the
data directory, `:64` loads and validates preferences, and `:135` saves state.
`src/application.cpp:801` defines native preferences; `src/zane-models.cpp:107`
parses the model catalog (`:124` reads reasoning efforts); `src/zane.cpp:960`
defines account-presence and automatic-access preferences. The working checkout
contains newer changes, so the tagged files are the authority for this version.
