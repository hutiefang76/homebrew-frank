class Frank < Formula
  desc "AI toolchain governance: manage skills + MCP across Claude Code / codex / opencode"
  homepage "https://github.com/hutiefang76/skills-frank"
  version "0.11.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "708bdc47193427cffed196b5d603843c0050b4ad9d3d6a35616a6f4d5b6a321e"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "f0dd689c02560d93ab68b537327180ad7a44fe503684fcfd785c5685c993e377"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2bdaa38d643cad47b99347eac5511b7ab334efd2ae5bd6a104869397c17ef648"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "251471894b2d46800ee423f62d6129b01cbe16d53a0aaae267852f9965b31c67"
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
