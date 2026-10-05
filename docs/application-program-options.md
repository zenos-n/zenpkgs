# Codex and Select for Figma

Configure `system.programs.codex` / `users.<name>.programs.codex`, or the
corresponding `select-for-figma` path. Both `enable` switches default to false.

Every preference defaults to null and preserves the existing live value. Selected
fields are reapplied on rebuild; removing a selection leaves the last live value.
Configuration remains writable. Restart running apps after changing preferences.
Named records preserve fields and entries you have not selected. Store credentials
in the app or keyring; environment-variable options name secrets without copying
them into the public Nix store. Codex TOML comments and both apps’ runtime state
are preserved. Changed files have a private `.zenos-backup` beside them.

Codex follows CODEX_HOME (default ~/.codex); stateDirectory also sets CODEX_HOME.
Figma Linux follows XDG_CONFIG_HOME/figma-linux (default ~/.config/figma-linux).
Activation uses the environment of the user activation service. Immutable config
symlinks require migration to writable files before selecting preferences.

Sources: [Codex reference](https://learn.chatgpt.com/docs/config-file/config-reference),
[Codex 0.159.0 schema](https://github.com/openai/codex/blob/rust-v0.159.0/codex-rs/core/config.schema.json),
[Figma Linux 0.11.5](https://github.com/Figma-Linux/figma-linux/tree/v0.11.5).

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
  canvasInterfaceScale = 1.0;
  fontSearchDirectories = [ "/run/current-system/sw/share/fonts" ];
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

| Option | Backend field | Details |
| --- | --- | --- |
| `showCreateFileButton` | `app.visibleNewProjectBtn` |  |
| `useSystemFileDialogs` | `app.useZenity` | Use Zenity system dialogs instead of the built-in Electron dialogs. |
| `forceStandardRgb` | `app.enableColorSpaceSrgb` | Force the sRGB color space. Restart the app to apply this choice. |
| `customThemes` | `app.disableThemes` | Allow custom desktop chrome themes; false uses the built-in theme. |
| `theme` | `theme.currentTheme` | Desktop chrome theme identifier. The built-in theme is 0; installed theme files supply other identifiers. |
| `restoreOpenFiles` | `app.saveLastOpenedTabs` | Restore the files that were open when the client last closed. |
| `exportDirectory` | `app.exportDir` | Absolute destination for exports. The directory must be writable by the user. |
| `fontSearchDirectories` | `app.fontDirs` | Directories recursively searched for fonts; include Nix font directories when needed. |
| `browserArguments` | `app.commandSwitches` | Chromium arguments such as --enable-gpu-rasterization or --force-device-scale-factor=1. Restart to apply. |
| `tabBarHeightPixels` | `app.panelHeight` |  |
| `tabBarScale` | `ui.scalePanel` |  |
| `canvasInterfaceScale` | `ui.scaleFigmaUI` |  |
| `logging` | `app.logLevel` |  |
| `themeEditor.legacyPreview` | `app.useOldPreviewer` | Use the older theme preview renderer in the theme editor. |
