# homebrew-frank

[Homebrew](https://brew.sh) tap for [**frank**](https://github.com/hutiefang76/skills-frank) — Rust CLI 治理 AI 工具链 (skills + MCP) 跨 Claude Code / codex / opencode 三平台。

## 装

```bash
brew install hutiefang76/frank/frank
```

第一次会自动 `brew tap hutiefang76/frank`,以后 `brew upgrade frank` 自动升最新。

## 装完干啥

```bash
frank login --from-host tx       # 从 deploy host 拉 sync-agent token
frank doctor                     # 11 项环境健康检查
frank daemon install             # 注册 launchd, 后台自启 + 开机起
frank                            # 裸命令自动开浏览器到 Web UI

# 装 skill / MCP
frank install frank-bridge       # /frank:ask:* slash 命令桥
frank install mcp-time           # MCP 注入 ~/.claude.json + ~/.codex/config.toml

# 全局扫
frank scan                       # 三平台 skills
frank scan --mcp                 # 三平台 MCP servers (识别 frank 装前 / 用户自装的)
```

## 支持平台

| OS | Arch | 状态 |
|---|---|---|
| macOS | Apple Silicon (arm64) | ✅ |
| macOS | Intel (x86_64) | ✅ |
| Linux | arm64 | ✅ (linuxbrew) |
| Linux | x86_64 | ✅ (linuxbrew) |
| Windows | x86_64 / arm64 | ❌ (用 [GitHub Release 的 .zip](https://github.com/hutiefang76/skills-frank/releases)) |

## 卸

```bash
brew uninstall frank             # 删 binary
brew untap hutiefang76/frank     # 删 tap 注册
```

`~/.frank/` 目录(token, state, logs)需要手动 `rm -rf ~/.frank/`,Homebrew 不动用户数据。

## 这个 tap 的源头

formula 跟着 [skills-frank](https://github.com/hutiefang76/skills-frank) 的 release 自动 bump (release.yml 里的 `homebrew-bump` job 会改这个 repo 的 `Formula/frank.rb`)。手动改请注意 `version` + 各架构 `sha256` 同步。

## License

MIT
