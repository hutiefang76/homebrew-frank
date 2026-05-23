class Frank < Formula
  desc "AI toolchain governance: manage skills + MCP across Claude Code / codex / opencode"
  homepage "https://github.com/hutiefang76/skills-frank"
  version "0.7.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "8d1426541aa1cd1dbc472dd9d2779ec32030e944158de7a68606e753a35854da"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "b2bcf391ab23da2d23929eb48fca0894434c9ec91109a04923631493b2138166"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c5b3cf97ff66d165afcd7fcc93f9c970f52f5d429a44242c303be183ccb7459a"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "98f47f52ad7dc10786cdb47f69a20b69aa35e943f4bf9f3348f6eeec8957fa4e"
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
