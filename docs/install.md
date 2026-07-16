# 安装与使用

## 这是什么

`interview-loop` 是一个 agent skill（Markdown 方法论 + 参考示例），通过 frontmatter
`name: interview-loop` 被 agent 运行时加载。它不是可执行程序，不需要编译。

## 安装

skill 本体在仓库的 `skill/` 目录，是一个自包含 bundle。把它整体放到你的 agent runtime
的 skills 目录即可。

```bash
git clone https://github.com/Beants/interview-loop.git
cd interview-loop

# 以 Claude Code / opencode 风格的 skills 目录为例：
cp -R skill ~/.claude/skills/interview-loop

# 或者用软链（便于随仓库更新）：
ln -s "$(pwd)/skill" ~/.claude/skills/interview-loop
```

> 安装路径按你自己的 agent runtime 调整。skill 的**激活名**是 `interview-loop`
> （由 `skill/SKILL.md` 的 frontmatter `name` 决定），与仓库名 / 目录名无关。

## 验证安装

安装后，在你的 agent 里描述一个面试准备场景，例如：

> 我要面试一位候选人，请帮我做岗位能力基准线解析。

如果 skill 被正确加载，agent 会按 `SKILL.md` 的流水线（面试官画像 → JD 解析 → 候选人分析 → …）响应。

## 用示例数据试跑

不用准备任何真实数据，直接用 `examples/` 下的虚构数据：

```bash
# 把示例 JD / 简历喂给加载了 skill 的 agent
```

示例：让 agent 基于 `examples/jd/后端架构AI工程化-示例JD.md` 做 Step 2（JD 解析），
或把 JD + `examples/resume/林沐-简历-示例.md` 一起喂给它做 Step 3（候选人分析）。

输出会写在 agent 的当前工作目录的 `面试分析/` 下。

## 用你自己的真实数据

真实面试数据**只允许**放进仓库根的 `data/`（已被 `.gitignore` 忽略，不会被提交）。
详见 [`privacy.md`](./privacy.md)。

```bash
# 把你的真实数据复制（不要软链）进 data/，然后在 data/ 下运行 skill
cp /path/to/your/private/jd.md data/
```

## 卸载

删除 skills 目录里的 `interview-loop` 即可。
