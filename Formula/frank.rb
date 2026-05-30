class Frank < Formula
  desc "AI toolchain governance: manage skills + MCP across Claude Code / codex / opencode"
  homepage "https://github.com/hutiefang76/skills-frank"
  version "0.15.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "f7a22a1282a7a40a582c620f6654910ebe1ee8ba9b405c10b21ab2b645ed8414"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "9e4c0a16334eb87a8e39057e92e80ce535b8fc426bec3c58b471d9101dadbf5d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "774e2c79f0fbae47ccc9e450283e65b54043dfc07036e68e2fb9be77b1f617bc"
    end
    on_intel do
      url "https://github.com/hutiefang76/skills-frank/releases/download/v#{version}/frank-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1ff02bd335dc8ab88936f5d7d1c60ffc94792152c96c6534e41e3383891096d0"
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
        1. Cross-machine sharing — memory + skills + MCP follow you everywhere
           跨机共享 — 记忆 + skills + MCP 在你所有机器间同步, 换台机器一键齐
        2. Cross-AI communication — ask claude/gpt/gemini/opencode, shared context
           跨 AI 交流 — 一行问任意 cli, 上下文互通 (claude 写的 codex review 拿得到)
        3. Frank-built skills — nacos / streampark / doris ops, ready to install
           芳哥自研 skills — nacos / streampark / doris 运维, 装了就用
        4. Frank-curated skills — hand-picked upstream (anthropics / community)
           芳哥推荐 skills — 精选 upstream (anthropics / 社区好货)
        5. [coming] Frank's powerful AI prompt engine
           [待开发] 芳哥强大的 AI 提示词功能

      ── What's new in v#{version} / 本版新增 ───────────────────────
        • Dynamic model list (models.dev, no longer hardcoded) — auto-refreshed 12h
          模型列表动态加载 (models.dev, 不再写死), 12 小时自动刷新当前模型
        • Cross-engine AI talk — frank-ask-<provider>-<model> variants
          跨引擎 AI 沟通 — claude 里调 frank-ask-codex 问 gpt, 反之亦然; 默认或指定模型
          (例 /frank-ask-claude-opus-4-8, /frank-ask-codex-gpt-5-5)

      ── Quick start / 开始用 ──────────────────────────────────────
        frank doctor              # health check / 体检
        frank list                # show all skills / 列出全部 skill
        frank install nacos-ops   # install a skill / 装一个 skill
        frank ai ask --opencode "hi"   # ask any AI / 跨 AI ask
        frank memory add "fact"   # add to memory / 加记忆
        frank ui                  # Web UI at 127.0.0.1:7780 / 开浏览器面板

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
