class Frank < Formula
  desc "AI toolchain governance: manage skills + MCP across Claude Code / codex / opencode"
  homepage "https://github.com/hutiefang76/skills-frank"
  version "0.13.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "862d3870d582fa3472e11742643e13bd41737e8a4c3a6768d02828f5b3a23676"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "158982ba0e62431ce5864fd2dec483baa54c140f84f344f62dfdc815b480f26c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6bccd2bf53eedaa852fcd972806b519aefb1657a09ae48444fc095d6d888a34d"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5322c757ec340a58855469281fc062540db0bf0cdf187c2d4bb740d9059ccc5a"
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

      🆕 v0.13.2 新增 (产品化收官):
        • 内置 skill 卸载保护 — frank-ask-* / frank-mem-* 是 frank 功能依赖, 默认拦,
          要 `--force-internal` 才放. 防误卸残废 frank.
        • MCP 真状态探活 — `frank list` 看 ~/.claude.json 等真 config 文件, 不只信 state.
          修 mcp-sequential-thinking 等误显 enabled 的问题.
        • 装前 preflight 检查 — `frank install frank-ask-gemini` 先 `which gemini`, 没装就警告.
        • doctor 加 tenant 状态 — 记录用量 / 配额 / 14d 删除倒计时, 一处全看.
        • history list 自动清 v0.10 前老条目 (静默, 不烦用户).
        • ai ask 4 家快捷开关: --claude / --gpt / --opencode / --gemini.
        • install <URL> 自动识别 git URL, 不用再写 --url.

      v0.13.0 服务端发 token (机器指纹 1:1 绑 tenant, 防 VM 集群匿名 spam, ADR-013).
      v0.12.0 服务端 tenant registry + 配额 10k records + 14 天删除流程.

      🆕 v0.12.0:
        • 自动注册 — 首次跑 frank 任何命令会随机生成 token 注册到默认 sync-agent
        • 配额 10k records / tenant — 满了 add 会拒, 查用量: frank tenant status
        • 删除流程 — frank tenant delete (14 天倒计时, frank tenant cancel-delete 撤回)
        • Claude hook 自动安装 — frank hook install (PostToolUse 截 mcp__memory → frank-memory)
        • CLAUDE.md 自动注入 — frank claude inject (把 frank-memory 介绍写入 ~/.claude/CLAUDE.md)

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
