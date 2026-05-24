class Frank < Formula
  desc "AI toolchain governance: manage skills + MCP across Claude Code / codex / opencode"
  homepage "https://github.com/hutiefang76/skills-frank"
  version "0.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "125868e07a5787b198ec3b7e45dc9564ad977ca80b7cbcb0e3ecd8925ac2db95"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "8d9725d2f980313d9890ac022251851801f37b7c13c32c3157d50bfcbb11c44c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "787846419c5b7b30bd8a7a9aa7cf232e82a5878e3c276aa0243b59e670317cb9"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5e334acb25b6bc38c0ed44a3eb70e853e1154825a766b9c2ec5d5070716e39b5"
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
        frank cleanup                         # 一行清 frank 官方装的全部 + 引导 brew 卸载
        brew services stop frank              # 停 daemon
        brew uninstall frank                  # 删 binary (brew 自动 untap)
        rm -rf ~/.frank/                      # 清 token / state / logs

      v0.7.3 起 `frank cleanup` (等价 `frank uninstall` 无参数) 只清 frank 官方装的
      (frank-official + frank-recommended); 用户自己 `frank install --url` 装的第三方
      (community/team/private) **不动** — 自己装的自己卸. 想一并清: `frank uninstall
      --including-3rd-party`.

      只跑 brew uninstall frank 会留: ~/.frank/, ~/.{claude,codex}/skills/frank-*,
      ~/.claude.json mcpServers 注入, ~/.codex/config.toml mcp_servers 注入. brew
      不知道这些是 frank 装的, **设计上不动用户数据** (ollama / postgres 同理).
      ============================================================

      文档: https://github.com/hutiefang76/skills-frank#readme
    EOS
  end
end
