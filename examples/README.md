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

## 隐私

- 这里**没有**任何真实数据。真实面试数据请放在仓库根的 `data/` 目录（已被 `.gitignore` 忽略），详见 [`../docs/privacy.md`](../docs/privacy.md)。
- 若你发现本目录任何内容疑似真实信息，请提 issue，我们会立刻核实。
