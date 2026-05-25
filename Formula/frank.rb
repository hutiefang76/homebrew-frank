class Frank < Formula
  desc "AI toolchain governance: manage skills + MCP across Claude Code / codex / opencode"
  homepage "https://github.com/hutiefang76/skills-frank"
  version "0.10.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "82dd3f71bcd521887d17343ee45c8c81ad82cec2190adc20003948a622d0a783"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "e9cf5d08888fd1f35593a7114c3e928c7a4e037be3c6ba94560e5ac788576999"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4f9dd34f7712cc12f0cb07a83f8754af92a7cd54bf8f3295a9e1e310f4bc11f3"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9e5e01affc7f3ddebc9acbfbb75dd8882c3bad44250488a4a58f55ff7e4d326a"
    end
  end

  def install
    bin.install "frank"
  end

  # v0.10.2: 删 service block — launchd-managed daemon 触发 macOS TCC 弹窗
  # (Apple Music / 照片 / 下载 / 文稿). 改为终端启动 `frank ui` 继承 TCC 不弹.
  # 详见 docs/known-issues.md 与 v0.10.2 release note.

  test do
    assert_match "frank #{version}", shell_output("#{bin}/frank --version")
  end

  def caveats
    <<~EOS
      frank #{version} 装好了。

      ▶ 启动 Web UI (一次性, 终端跑, Ctrl-C 退, **不弹 TCC 权限**):
        frank ui                              # 自动开浏览器到 http://127.0.0.1:7780
        frank ui --no-open                    # ssh 隧道 / headless 场景
        frank ui --bind 127.0.0.1:7799        # 自定义端口

      ⚠️  v0.10.2 起 **不再用 brew services** — 之前 `brew services start frank`
      启的 launchd daemon 会触发 macOS TCC (Apple Music / 照片 / 下载 / 文稿弹窗),
      因为 launchd 启动的进程不继承用户 Terminal 的 TCC 授权. 终端 `frank ui` 继承
      终端授权, 永不弹.

      如果你 < v0.10.2 装过 brew services 起的 daemon, 升级后请清:
        brew services stop frank              # 停旧 launchd
        rm -f ~/Library/LaunchAgents/homebrew.mxcl.frank.plist

      首次配置 (可选):
        frank login                           # sync-agent token 引导
        frank config detect-proxy             # 自动配 Clash/Surge 代理
        frank install <name>                  # 装 skill / MCP (走 libgit2)

      ============================================================
      ⚠️  彻底卸载 (Homebrew 设计不动用户数据, 必须**先**清):
        frank cleanup                         # 一行清 frank 官方装的全部
        brew uninstall frank                  # 删 binary (brew 自动 untap)
        rm -rf ~/.frank/                      # 清 token / state / logs

      v0.7.3 起 `frank cleanup` (等价 `frank uninstall` 无参) 只清 frank 官方装的
      (frank-official + frank-recommended). 用户自己 `frank install --url` 装的
      第三方不动. 想一并清: `frank uninstall --including-3rd-party`.
      ============================================================

      文档: https://github.com/hutiefang76/skills-frank#readme
    EOS
  end
end
