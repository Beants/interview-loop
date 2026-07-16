# 技术测试用例：interview-loop 开源隔离实现

> 实现员从**实际实现**推导的技术 / 集成侧测试用例，补充 `business-test-cases.md`（业务侧）。
> 执行由门禁执行器负责（`scripts/check-pii.sh` + clone 走查）；本文件只定义用例（输入 + 预期）。
>
> 注：为避免把真实指纹写进仓库，本文件一律用「真实姓名清单 / 真实公司名 / 真实业务指纹」
> 指代 `scripts/check-pii.sh` 里维护的具体正则模式，不重复罗列字面量。

---

### TC-T01: PII 扫描覆盖工作树 + git 历史
- **类型**: 集成 / 自动化
- **输入**: 仓库工作树与 `git rev-list --all` 全部提交
- **预期**: `scripts/check-pii.sh` 对真实姓名 / 公司 / 业务指纹 / 私有路径扫描，工作树与历史命中数均为 0，exit 0。
- **关联**: 业务 TC-001 / TC-002

### TC-T02: PII 扫描器自排他（不误报自身字面量）
- **类型**: 边界
- **输入**: `scripts/check-pii.sh` 自身源码（含被禁模式的字面量定义）
- **预期**: 工作树扫描通过 `--exclude=check-pii.sh`、历史扫描通过 pathspec `:(exclude)scripts/check-pii.sh` 排除自身；脚本不因匹配自己的模式定义而误报。
- **备注**: 防止「扫描器把自己判成泄漏」的退化。

### TC-T03: PII 扫描器对新增 PII 命中即 exit 1（防呆）
- **类型**: 错误
- **输入**: 在仓库根（非 `data/`、非 `skill/references/`）放一个含真实姓名 / 公司 / 私有路径 / 业务指纹的文件
- **预期**: `scripts/check-pii.sh` 命中并 exit 1（即便 `.gitignore` 未覆盖该位置）。
- **关联**: 业务 TC-011（三重防护中扫描层独立兜底）

### TC-T04: `.gitignore` 白名单保留 `data/` 占位
- **类型**: 边界 / 自动化
- **输入**: `.gitignore` 中的 `/data/*` + `!/data/.gitkeep` + `!/data/README.md`
- **预期**: `git check-ignore data/真实简历.md` 命中（被忽略）；`git check-ignore data/.gitkeep` 与 `data/README.md` 不命中（被白名单保留）；`data/` 目录结构存在于仓库。
- **关联**: 业务 TC-006 / TC-007

### TC-T05: `.gitignore` 不误伤 `examples/` 合法示例
- **类型**: 边界
- **输入**: `examples/resume/林沐-简历-示例.md`（文件名含「简历」）
- **预期**: `git check-ignore` 不命中（被跟踪）。仓库**未使用** `*简历*.md` 这类宽泛通配符。
- **关联**: design.md §2 设计取舍

### TC-T06: 仓库不含产物 / OS 元数据
- **类型**: 业务 / 自动化
- **输入**: 仓库根
- **预期**: 不存在 `interview-loop.zip`、`.DS_Store`、`__MACOSX/`（`ls` + gitignore 双保险）。
- **关联**: 业务 TC-008

### TC-T07: skill 内部零绝对私有路径
- **类型**: 业务 / 可移植
- **输入**: `skill/SKILL.md`、`skill/references/*.md`
- **预期**: 不出现 `/Users/` 开头的绝对路径；reference 引用为相对 `references/`，输出目录为相对 `面试分析/`。
- **关联**: 业务 TC-009

### TC-T08: skill 可整体复制安装
- **类型**: 集成
- **输入**: `skill/` 目录
- **预期**: `skill/SKILL.md` frontmatter 含 `name: interview-loop`；`skill/references/` 含 7 个示例文件；`cp -R skill <skills>/interview-loop`（把 `skill/` 整体复制成 skills 目录下的 `interview-loop/`）或软链后可被 runtime 识别。
- **关联**: 业务 TC-003

### TC-T09: examples 自洽可驱动 skill
- **类型**: 集成
- **输入**: `examples/jd/后端架构AI工程化-示例JD.md` + `examples/resume/林沐-简历-示例.md`
- **预期**: JD 与简历角色 / 公司 / 项目自洽（同属虚构「星澜科技」「林沐」场景），可驱动 skill 完成 Step 2（JD 解析）或 Step 3（候选人分析）。
- **关联**: 业务 TC-004

### TC-T10: examples 显式声明虚构
- **类型**: 业务 / 合规
- **输入**: `examples/README.md`
- **预期**: 文件含「全部为虚构…与任何真实人物 / 公司无关」的中英文声明。
- **关联**: 业务 TC-005

### TC-T11: CI 把 PII 扫描作为硬门禁
- **类型**: 流程
- **输入**: `.github/workflows/pii-scan.yml` + 任意 PR
- **预期**: workflow `fetch-depth: 0`（保留全历史），`bash scripts/check-pii.sh` 非零退出阻断合并。
- **关联**: 业务 TC-010

### TC-T12: 仓库精简（文件数受控）
- **类型**: 边界
- **输入**: 仓库已跟踪文件
- **预期**: 不含构建产物与冗余；根 meta 文件齐全（`README.md` / `LICENSE` / `.gitignore` / `.gitattributes`）。
- **关联**: PRD 成功指标「文件数 ≤ 20」精神（首版）

---

## 覆盖度自检
- 集成 / 可移植：TC-T08 / TC-T09
- 边界（白名单 / 自排他 / 不误伤）：TC-T02 / TC-T04 / TC-T05 / TC-T06 / TC-T12
- 错误 / 防呆：TC-T03
- 流程门禁：TC-T01 / TC-T11
- 合规声明：TC-T10
- 可移植契约：TC-T07
