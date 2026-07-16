# interview-loop

> 一套自进化的面试辅助 skill：降低面试官准备成本、提升评估准确度，通过闭环反馈让每次面试都比上一次更好。

本仓库开源的是一个 **Claude / agent skill**（`interview-loop`），以及让任何人 clone 后即可独立试跑的虚构示例数据。

- 仓库组织：`Beants/interview-loop`
- Skill 激活名：`interview-loop`（由 `skill/SKILL.md` 的 frontmatter `name` 决定，与仓库名 / 目录名解耦）

## 这是什么

`skill/` 目录是一个可整体复制到 `~/.claude/skills/interview-loop/` 的自包含 skill bundle。它提供一条 7 步面试流水线（面试官画像 → JD 解析 → 候选人分析 → 面试策略 → 定制面试题 → 面试评价 → 闭环反馈），核心方法论见 [`skill/SKILL.md`](./skill/SKILL.md)。

`examples/` 提供一份**完全虚构**的 JD / 简历 / 面试记录，让你不依赖任何真实数据就能走完流水线的至少一个步骤。

## 快速开始

```bash
git clone https://github.com/Beants/interview-loop.git
cd interview-loop

# 安装 skill（把 skill/ 复制成 skills 目录下的 interview-loop/）
cp -R skill ~/.claude/skills/interview-loop   # 路径按你的 agent runtime 调整

# 用虚构数据试跑：把 examples/ 下的 JD / 简历喂给加载了该 skill 的 agent
```

详细安装步骤见 [`docs/install.md`](./docs/install.md)。

## 目录结构

```
interview-loop/
├── skill/                  # skill 本体（开源核心，可整体复制到 skills 目录）
│   ├── SKILL.md
│   └── references/         # 7 个流水线输出格式示例（全部脱敏 / 虚构）
├── examples/               # 虚构示例数据（clone 即跑）
│   ├── jd/  resume/  transcript/
│   └── README.md           # 声明：全部虚构，与任何真人/公司无关
├── data/                   # 私有数据唯一落点（内容被 gitignore，仅留占位）
├── scripts/check-pii.sh    # PII 正则扫描（CI 硬门禁）
└── docs/                   # privacy.md / install.md
```

## 开源 vs 私有边界（一句话）

> **`skill/` + `examples/` 公开；`data/` 私有；真实面试数据绝不入库；skill 对数据位置无感。**

- skill 内部只用相对路径，输入由调用方在运行时提供，输出写到当前工作目录的 `面试分析/`。
- 你自己的真实面试数据**只允许放进 `data/`**（已被 `.gitignore` 覆盖）。详见 [`docs/privacy.md`](./docs/privacy.md)。
- 防泄漏靠三重防护：目录约定 + `.gitignore` + `scripts/check-pii.sh`（CI 硬门禁）。

## 隐私与脱敏

仓库中所有示例人物、公司、项目、指标均为**虚构同构数据**，不指向任何真实个人或组织。提交前请运行：

```bash
bash scripts/check-pii.sh
```

详见 [`docs/privacy.md`](./docs/privacy.md)。如果你发现任何疑似真实信息，欢迎提 issue。

## 贡献

欢迎提 issue / PR。请注意：

- 不要提交任何真实候选人 / 面试官数据。
- 修改 `skill/` 内容时，保持相对路径原则（详见 `docs/privacy.md`）。
- PR 会自动跑 PII 扫描，命中真实姓名 / 公司 / 私有路径会被阻断。

## 许可证

[MIT](./LICENSE)
