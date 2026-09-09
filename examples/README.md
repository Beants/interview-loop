# examples — 虚构示例数据

> ⚠️ **本目录下所有数据均为虚构，与任何真实人物、公司、项目、产品无关。**
>
> These sample datasets are **entirely fictional**. Any resemblance to real persons,
> companies, projects, products, or metrics is coincidental. They exist only so that the
> `interview-loop` skill can be exercised end-to-end without any private data.

## 用途

让任何人 `git clone` 本仓库后，无需准备任何真实面试数据，就能驱动 `interview-loop`
skill 走完流水线的至少一个步骤（例如 Step 2 JD 解析、或 Step 3 候选人分析）。

## 内容

这是一组**内部自洽**的虚构场景：候选人「林沐」应聘虚构公司「星澜科技」的
「后端架构师 / AI 工程化专家」岗位。

| 文件 | 对应 skill 步骤 | 说明 |
|------|----------------|------|
| [`jd/后端架构AI工程化-示例JD.md`](./jd/后端架构AI工程化-示例JD.md) | Step 2 输入 | 虚构岗位说明书 |
| [`resume/林沐-简历-示例.md`](./resume/林沐-简历-示例.md) | Step 3 输入 | 虚构候选人简历 |
| [`transcript/林沐-面试记录-示例.txt`](./transcript/林沐-面试记录-示例.txt) | Step 6 输入 | 虚构面试录音转写 |

## 怎么用

把加载了 `interview-loop` skill 的 agent 指向这些文件，例如：

> 请用 interview-loop skill，基于 `examples/jd/后端架构AI工程化-示例JD.md` 做岗位能力基准线解析（Step 2）。

或把简历 + JD 一起喂给它做候选人综合分析（Step 3）。

## 软性素质对比（要求 × 表现）全链路

这套虚构数据还能驱动 skill 的**软性素质三段闭环**——无需任何额外真实数据：

> JD 要求挖掘（Step 2）→ 简历证据挖掘（Step 3）→ 定向探查（Step 5）→ 要求 × 表现逐项对比（Step 6）→ 横向对比（Step 6）→ 证据覆盖校准（Step 7）

- 用 `jd/后端架构AI工程化-示例JD.md` 跑 Step 2，可产出该岗位的「JD 软性素质要求清单」（每项六要素，JD 驱动，词典做归一化）。
- 用 `resume/林沐-简历-示例.md` + 清单跑 Step 3，可逐项挖简历证据、标缺口 / 存疑。
- 用 `transcript/林沐-面试记录-示例.txt` 跑 Step 6，可输出「要求 × 表现逐项对比」（✅有证据支撑 / ❌缺失 / ❓存疑三态，引用原文）。

一份**已填好的虚构示例输出**见 [`../skill/references/软性素质要求×表现对比-示例.md`](../skill/references/软性素质要求×表现对比-示例.md)（同属「星澜科技 / 林沐」场景，含三态、缺口风险点、横向对比样例）。归一化词典见 [`../skill/references/软性素质词典-参考.md`](../skill/references/软性素质词典-参考.md)。

## 隐私

- 这里**没有**任何真实数据。真实面试数据请放在仓库根的 `data/` 目录（已被 `.gitignore` 忽略），详见 [`../docs/privacy.md`](../docs/privacy.md)。
- 若你发现本目录任何内容疑似真实信息，请提 issue，我们会立刻核实。
