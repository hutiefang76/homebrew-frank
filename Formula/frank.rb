class Frank < Formula
  desc "AI toolchain governance: manage skills + MCP across Claude Code / codex / opencode"
  homepage "https://github.com/hutiefang76/skills-frank"
  version "0.5.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "7e7e7472d8d8739d58e4de3f4c7e3c24427ba1e9b7f10552c711cb318ca71fdb"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "95e25838f22c5002d0ae565655dca0bdf336c711c817b5eb9de73ca1581f6349"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b483134b95edb42972038304d2ad48137973b427784cc31191718630d8ff0c63"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cd257185068a9983c2c713ce61d73bf38ad947afe8e0205a048206e804d5fde9"
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
