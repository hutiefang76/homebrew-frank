class Frank < Formula
  desc "AI toolchain governance: manage skills + MCP across Claude Code / codex / opencode"
  homepage "https://github.com/hutiefang76/skills-frank"
  version "0.6.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "95bc9a1371e0a7a19d6b6d975377aa6b99e3a81b28cad016c277dd4173960f26"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "fc0e75baf214ba9a0d36a47ec8f28c288732769c132e88a7275861a249e28f72"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1028e0e50eebbd92bd70b4ddeacd905130eda7a812c0c99965292582b8327030"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "beae6f27391715cd9006fc0b0ee568f3e3c74fd5210e2e3de92422aef692954c"
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
      frank 装好了。

      启动后台服务 (Web UI + orchestrator):
        brew services start frank          # 一次, 重启自动起
        open http://127.0.0.1:7780         # Web UI

      日常控制:
        brew services list                 # 看状态
        brew services stop frank
        brew services restart frank
        brew uninstall frank               # 自动 stop + 清服务注册

      首次配置 sync-agent token (用 memory / 跨设备同步才需要):
        frank login                        # 看引导

      文档: https://github.com/hutiefang76/skills-frank#readme
    EOS
  end
end
