class Frank < Formula
  desc "AI toolchain governance: manage skills + MCP across Claude Code / codex / opencode"
  homepage "https://github.com/hutiefang76/skills-frank"
  version "0.7.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "bb450943ffdb84899b818224f8a1b09cfbcb6abf401e0f58fb0019c0a1fd65bf"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "8abc2bf751f37f79eef603cb0264d78d54f1d7f80fa251a94896b90906f7ecca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9f7cdc5f7d99bed89bc46c455e5bd18e9f97a5f9b5af540afe2661ad88a2f46f"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "96bf3d6bc8e5e02f82b8cb4b36c0faa9da9a905513cacc7c4cf1b233f35fd07b"
    end
  end

  def install
    bin.install "frank"
  end

  service do
    run [opt_bin/"frank", "orchestrator", "serve", "--bind", "127.0.0.1:7780"]
    keep_alive true
    log_path var/"log/frank/orchestrator.log"
    error_log_path var/"log/frank/orchestrator.error.log"
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match "frank #{version}", shell_output("#{bin}/frank --version")
  end

  def caveats
    <<~EOS
      frank #{version} 装好了。

      启动后台服务 (Web UI + orchestrator):
        brew services start frank          # 一次, 重启自动起
        open http://127.0.0.1:7780         # Web UI

      日常控制:
        brew services list                 # 看状态
        brew services restart frank
        brew services stop frank

      首次配置 (可选):
        frank login                        # sync-agent token 引导
        frank config detect-proxy          # 自动配 Clash/Surge 代理
        frank install <name>               # 装 skill / MCP (走 libgit2, 不需系统 git)

      ============================================================
      ⚠️  彻底卸载 (Homebrew 设计不动用户数据, 必须**先**清):
        frank uninstall --all --purge-cache   # 清三平台 skill / MCP / cache
        brew services stop frank              # 停 daemon
        brew uninstall frank                  # 删 binary (brew 自动 untap)
        rm -rf ~/.frank/                      # 清 token / state / logs

      只跑 brew uninstall frank 会留: ~/.frank/, ~/.{claude,codex}/skills/frank-*,
      ~/.claude.json mcpServers 注入, ~/.codex/config.toml mcp_servers 注入. brew
      不知道这些是 frank 装的, **设计上不动用户数据** (ollama / postgres 同理).
      ============================================================

      文档: https://github.com/hutiefang76/skills-frank#readme
    EOS
  end
end
