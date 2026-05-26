class Frank < Formula
  desc "AI toolchain governance: manage skills + MCP across Claude Code / codex / opencode"
  homepage "https://github.com/hutiefang76/skills-frank"
  version "0.14.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "1657c4dc9f650465d990eae1285ef4f4b8d554b9250b9f72babf55fbe2350c7f"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "e00ec41a3a93cf5da581e135928db432c45bd4511f1e467a9d3790d753bac172"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d2ec0a6fc7cf5a2010bd11b62b663ca695b864d5eaea3b9ab041cbbe04bfed7a"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2a04473ff7cef0dfc26c115bad93c41f52c8e29c7ab4a3395f07a21729f58fd4"
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
      frank #{version} installed / 装好了。

      ── What is frank / Frank 是啥 ─────────────────────────────────
        Govern AI toolchains across Claude Code / codex / opencode:
        skills + MCP + distributed memory + cross-AI ask, one CLI.
        跨 3 个 AI CLI 平台治理 skill + MCP + 分布式记忆 + 跨 AI ask,
        一个命令搞定全部。

      ── Main features / 主要功能 ──────────────────────────────────
        • Skill + MCP install/uninstall, three platforms in sync
          Skill + MCP 一键装卸, 三平台同步
        • Distributed memory: LanceDB local + Qdrant server, Hybrid RRF
          分布式记忆: LanceDB 本地 + Qdrant 服务端, Hybrid RRF 召回
        • Cross-AI ask: --claude / --gpt / --opencode / --gemini
          跨 AI ask: 一行调四家 cli
        • Machine-bound tenant token, 10k records quota, 14d deletion
          机器绑定 token, 10k 配额, 14 天删除流程

      ── What's new in v#{version} / 本版新增 ───────────────────────
        • Cross-machine skill sync — `frank tenant sync` pulls and installs
          跨机 skill 同步 (服务端记你装过啥, 新机器一键齐)
        • MCP 4 platforms unified — claude + codex + gemini + opencode all write
          MCP 4 家全通 (gemini + opencode 补齐)
        • Memorix-style hook UI feedback — Claude shows "[frank-memory] saved: ..." inline
          Memorix 风格 hook 反馈 (Claude 界面内联提示已存)
        • `frank mcp-shim` credential-operation separation — 0 creds in ~/.claude.json
          凭证-操作分离 (一个 MCP 多 profile 跑多套连接, 凭证 0 进 ~/.claude.json)
        • GitHub mirror fallback for slow networks
          国内访问慢的兜底 (frank config set mirror.github <url>)

      ── Quick start / 开始用 ──────────────────────────────────────
        frank doctor              # health check / 体检
        frank list                # show all skills / 列出全部 skill
        frank install nacos-ops   # install a skill / 装一个 skill
        frank ai ask --opencode "hi"   # ask any AI / 跨 AI ask
        frank memory add "fact"   # add to memory / 加记忆
        frank ui                  # Web UI at 127.0.0.1:7780 / 开浏览器面板

      ── After login, you can / 登陆后能干嘛 ───────────────────────
        • Share distributed memory across multiple machines (frank tenant link)
          多机共享同一份分布式记忆 (登陆同 token 后, A 机存的记忆 B 机能搜到)
        • [v0.14 roadmap] Auto-sync installed skills + MCP across machines
          [v0.14 路线图] 跨机自动同步已装 skills 和 MCP, 一次装多机用

      ── Uninstall / 卸载 ──────────────────────────────────────────
        frank cleanup          # uninstall skills written by frank itself only
                               # 只卸 frank 自家写的 skill (nacos-ops 等);
                               # 你装的 upstream (skill-creator 等) 和自装的不动
        brew uninstall frank   # uninstall frank command itself / 卸载 frank 命令本身
        rm -rf ~/.frank/       # remove all frank local state / 清掉 frank 在本地的所有状态

      Docs / 文档: https://github.com/hutiefang76/skills-frank#readme
    EOS
  end
end
