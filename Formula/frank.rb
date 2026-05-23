class Frank < Formula
  desc "AI toolchain governance: manage skills + MCP across Claude Code / codex / opencode"
  homepage "https://github.com/hutiefang76/skills-frank"
  version "0.5.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "badd467967850edc4297f26ae1b5b444dbd06359005abe71d591aaed387a4149"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "3f0f3e36378892beef9641ab49dd3be8d5e2240d5ed87eb1fcd9763208cd1b9e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d713ca12f0fbe4807fd0b24f5a20638b5faed51783cf4a899d2a1c25d43a2ba4"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2b604fbb226742f3d082ab090656c35dd88e495391df06b7622dbeb50c9383f3"
    end
  end

  def install
    bin.install "frank"
  end

  test do
    assert_match "frank #{version}", shell_output("#{bin}/frank --version")
  end

  def caveats
    <<~EOS
      frank 装好了。下一步:

        frank login --from-host tx     # 拉 sync-agent token (无 token 时 memory / orchestrator 命令会 401)
        frank doctor                   # 11 项环境健康检查
        frank daemon install           # 注册 launchd 服务 + 浏览器开 http://127.0.0.1:7780

      文档: https://github.com/hutiefang76/skills-frank#readme
    EOS
  end
end
