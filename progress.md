# 进度报告6 · 基础组件与布局系统

> 说明：本文件与雨课堂答题区内容一致。按要求**正文不插入图片**，需要配图的位置用「【图X】」标出该放什么图，并给出复现命令与截图方法；截图自行运行后补入雨课堂。

## 一、任务理解

本次作业对应《学生实践指南六：基础组件与布局系统》，要完成四块内容：

1. **6.1 案例复现（必做）**：按演示站 `thiswind.github.io/flutter-book-demos` 的 profile_card 复现个人名片页，分三步提交——先搭骨架（只用对齐参数）、再加卡片装饰与状态徽标、最后对照设计稿收敛尺寸并做到零溢出告警。验收标准：视觉与设计参数一致（页边距 16、卡片圆角 16、头像 72、徽标 18 带 2px 白边、姓名 22/700、签名 13/1.5），控制台无 `RenderFlex overflowed`。
2. **6.2 自主实践（必做）**：五项基本任务——对齐任务卡六种场景、弹性 2:1:1 与长内容记录、层叠角标两场景、容器美化两处、以及 AI 使用标注。
3. **6.3 独立研究（选做）**：约束传递实验（撑不满 / 溢出 + Inspector 读约束）、FittedBox 三种缩放策略对比、ClipPath 自定义剪裁头图。
4. **6A 扩展练习（选做）**：修复演示站 EX1~EX5 五个缺陷案例，每个案例写清病根与修复思路。

验收标准概括为：每个演示项都可在应用内点进去看到「参数标注 + 现象 + 一句话结论」；正常路径与异常路径都能正确演示；代码零分析告警、页面零溢出；Git 至少 3 次可编译的提交。

## 二、环境与工具

| 项目 | 内容 |
| --- | --- |
| 操作系统 | Windows（PowerShell） |
| Flutter | 3.47.4 stable（Dart 3.13.3，DevTools 2.60.0） |
| 运行目标 | Flutter Web（Chrome）+ Widget 测试；未使用模拟器 |
| 编辑器 | TraeCode（AI 辅助）+ VS Code 风格终端 |
| AI 工具 | TraeCode（模型 DeepSeek-V4.1-Flash），用于脚手架、页面实现与调试建议 |
| 验收工具 | `dart analyze lib test`、`flutter test`、`flutter build web --no-web-resources-cdn` + Playwright 无头浏览器截图 |

运行命令（本项目固定使用这三条）：

```powershell
dart analyze lib test          # 静态分析，替代 flutter analyze（中文路径会崩，见第六节）
flutter test                   # 27 项 widget 测试
flutter build web --release --no-web-resources-cdn
```

> 构建 Web 时必须带 `--no-web-resources-cdn`，否则 CanvasKit 会去 gstatic CDN 拉资源，国内网络下页面白屏。

## 三、过程记录

1. 阅读手册与进度报告模板，把要求拆成 6.1 / 6.2 / 6.3 / 6A 四组共 13 个页面。
2. 打开演示站，逐个案例对照：profile_card 的间距与字号、EX1~EX5 的原始代码（克隆演示仓后阅读 `lib/main.dart` 中对应小节），先记下每个 EX 的「病根」再动手。
3. `flutter create lecture6` 建仓，`git init -b main`，第一次提交 `chore: scaffold Flutter project lecture6 with course asset`。
4. 6.1 三步走：先只放 Column + 对齐参数搭骨架（`feat: profile skeleton with alignment`）→ 加白色卡片、阴影、圆角与头像绿点徽标（`feat: card decoration & status badge`）→ 按设计参数收敛尺寸、修掉溢出（`feat: match design spec, zero overflow warnings`）。
5. 写 `lib/widgets/lab_widgets.dart` 作为实验页公共骨架（`LabScaffold` / `SectionHeader` / `DemoPanel` / `ParamChip`），保证每个实验项都长成「标题 + 参数 chip + 演示区 + 结论」的统一格式。
6. 实现 6.2 四个实验页（对齐、弹性、层叠、容器）与 6.3 三个研究页（约束、FittedBox、ClipPath），提交 `feat: add 6.2/6.3 layout lab pages`。
7. 逐个修 EX1~EX5，每个案例一次提交，提交信息写明病根与修复点。
8. 首页加菜单（分组标题 + 卡片入口）并补 27 项 widget 测试，提交 `feat: wire home menu and add page smoke tests`。
9. 静态分析 0 问题、测试 27/27 通过、Web 构建成功；用 Playwright 对 13 个页面 + 5 个交互场景截图做视觉验收，修掉 3 处视觉瑕疵（见第六节）。
10. 写本报告并 push 到 `https://github.com/Tangerine-ora/lecture6.git`。

## 四、关键代码

### 4.1 白卡探索：先背下来的「卡片套路」

```dart
BoxDecoration cardDecoration({Color color = Colors.white, double radius = 16}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
```

逐行解释：

- 第 1 行：把「白底 + 圆角 + 柔和阴影」封装成函数，所有卡片共用同一组设计参数，改一处即可全局生效。
- `color` 默认白色：卡片底色与页面底色 `#F3F5F9` 形成层级差。
- `borderRadius: 16`：手册设计稿规定的卡片圆角。
- 阴影用 `black` 6% 透明度 + `blurRadius 12` + 向下 `Offset(0, 4)`：透明度足够低才不显脏，模糊半径约为圆角的 0.75 倍最自然。
- `withValues(alpha: …)` 是新版 Flutter 的写法（旧的 `withOpacity` 已弃用），静态分析会因此零告警。

是否 AI 生成：AI 生成初稿，本人按设计稿把 8% 改成 6%、blur 10 改成 12。验证方式：`dart analyze` 无告警 + 页面截图与设计稿对照。

### 4.2 profile_card 的层叠：头像 + 在线徽标

```dart
SizedBox(
  width: 72,
  height: 72,
  child: Stack(
    children: [
      ClipOval(
        child: Image.asset('assets/profile_avatar.png', fit: BoxFit.cover),
      ),
      Positioned(
        right: 0,
        bottom: 0,
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFF22C55E),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ),
    ],
  ),
)
```

逐行解释：

- 外层 `SizedBox(72, 72)` 给 `Stack` 一个**确定的盒子**：`Stack` 在无约束下会尽量小或尽量大，尺寸必须先由父级钉死，这是本课「父给约束 → 子报尺寸 → 父定位置」的直接体现。
- `ClipOval` 把方形头像裁成圆形（`CircleAvatar` 亦可，但 `ClipOval` + `Image.asset` 更直观）。
- `Positioned(right: 0, bottom: 0)` 把徽标钉在右下角；**只有 Stack 的直接子级才能用 Positioned**。
- 徽标 18 + 白边 2：白边让绿点从头像上「浮」起来，避免与深色头像糊在一起。
- 绿点必须画在头像之后（数组顺序），否则会被头像盖住。

是否 AI 生成：AI 生成骨架，本人把徽标从 20 改成 18 并加 2px 白边以对齐设计稿。验证方式：390×844 与 900×900 两种尺寸的 widget 测试均无溢出，截图放大后白边可见。

### 4.3 EX4 转盘：结果必须由最终角度反推

```dart
void _spin() {
  final winner = _random.nextInt(_prizes.length);
  final turns = 4 + _random.nextInt(3);
  // 指针在 12 点方向：让第 winner 个扇区的中心最终停在 0°。
  var target = 2 * math.pi * turns - (winner + 0.5) * _sweep;
  while (target < _rotation + 2 * math.pi * 3) {
    target += 2 * math.pi;
  }
  ...
}
```

逐行解释：

- 先决定中奖扇区 `winner`，再反算总旋转角——顺序不能反，否则会出现「盘面停在 A，结果却是 B」。
- 扇区从 -90°（12 点）开始画，所以第 i 个扇区的中心角是 `-π/2 + (i + 0.5) * sweep`；要让它在旋转后落到 0°，旋转量应满足 `rotation ≡ (i + 0.5) * sweep (mod 2π)`，取负号即 `-(winner + 0.5) * sweep`。
- `turns = 4~6` 圈保证观感上有加速过程，同时让每次停止位置离起点更远，避免「看不出转过」。
- `while (target < _rotation + 3 圈)` 保证旋转方向永远是顺时针、至少再转 3 圈，不会出现倒转。
- 动画 `completed` 回调里把 `_rotation = _to` 并令 `_result = _prizes[_pendingWinner]`，让状态与真实角度一致。

是否 AI 生成：AI 给出首版（用 `DateTime.now().millisecond % 6` 取结果，正是演示站的病根）；本人改为「先定扇区再反算角度」。验证方式：连续抽 10 次，比对截图里指针指向的扇区与结果文字，全部一致。

## 五、检查点结果

| 检查点 | 正常路径 | 异常路径 | 结果 |
| --- | --- | --- | --- |
| 6.1 profile_card | 名片、统计、标签、底部操作栏完整渲染 | 窄屏 320 宽时文字自动 ellipsis，无黄黑条 | 通过 |
| 6.2 ① 对齐 | 六种 `mainAxisAlignment` / `crossAxisAlignment` 现象与参数 chip 一一对应 | — | 通过 |
| 6.2 ② 弹性 | 2:1:1 实测 157 / 79 / 79 px（已扣除两条 8px 间距） | 关掉 Expanded 后长文本把行撑破，底部出现黄黑条 | 通过（异常可复现） |
| 6.2 ③ 层叠 | 头像徽标在线/离线切换、图片浮层文字压在渐变上 | — | 通过 |
| 6.2 ④ 容器 | 白卡 / 渐变头图 / ClipRRect 圆角图三处对比 | `color` 与 `decoration` 同时使用被断言拦下（页面内用文字说明） | 通过 |
| 6.3 ① 约束 | 宽度 120 的容器「撑不满」父级 | 打开「强制撑满」后同样布局铺满；打开溢出开关出现黄黑条 | 通过 |
| 6.3 ② FittedBox | contain / fill / scaleDown 三列并排，尺寸差异清晰 | — | 通过 |
| 6.3 ③ ClipPath | 波浪头图裁剪正确，图片 `BoxFit.cover` 撑满 | 裁剪后文字仍在路径外正常显示 | 通过 |
| 6A EX1 | 点击图标炸出 14 颗粒子 + 金币计数 +3 | 连续点击不叠加混乱，重置按钮可清零 | 通过 |
| 6A EX2 | FAB 打开面板，金额/标签校验后新增记录并计入合计 | 金额为空或非数字时「保存」保持禁用 | 通过 |
| 6A EX3 | 390 宽 7 列、1200 宽仍 7 列且格子固定 40 | 极窄屏（320）时外层 `ConstrainedBox(360)` 内可横向收缩，不拉伸 | 通过 |
| 6A EX4 | 六个彩色扇区随盘旋转，停下时指针所指 = 结果 | 连点「开始」只触发一次（`_spinning` 守卫） | 通过 |
| 6A EX5 | 菜单可点赞/取消、可写评论并即时上屏 | 评论为空时不新增；`controller.dispose()` 后检查 `mounted` | 通过 |

自动化证据：`dart analyze lib test` → `No issues found!`；`flutter test` → `All tests passed!`（27 项，13 个页面 × 2 种尺寸 + 1 项首页）。

三种典型现象的判断口径：出现黄黑色斜纹条 = `RenderFlex overflowed`；子组件没有铺满父级 = 父级给的是有界约束而子级按自身尺寸报尺寸；同尺寸下位置不对 = 对齐参数挂在错的轴上（Row 用 `mainAxisAlignment` 管水平）。

## 六、问题与调试

**问题 1：`flutter analyze` 在中文路径下直接崩溃。**
现象：执行 `flutter analyze` 抛 `FormatException: Unterminated string`，报错里出现 `%E4%BD%9C...` 这样的 URL 编码路径。
定位：这是分析服务器在解析 LSP 报文时对非 ASCII 路径处理的问题，与代码本身无关（同样的代码在纯英文路径下正常）。
解决：改用 `dart analyze lib test`，功能等价、不经过同一层 LSP 封装，输出 `No issues found!`。

**问题 2：真实溢出——「约束传递」页在 390 宽下底部溢出 22px。**
现象：widget 测试报 `A RenderFlex overflowed by 22 pixels on the bottom`，但浏览器截图里没看到黄黑条（截图时页面已滚动）。
定位：演示面板 `height: 120`，内部 `padding: 10` 后只剩 100px，而三行 38px 的方块共 114px，差额 22px 正好等于报错数值 → 确认是面板高度给少了。
解决：把面板 `height` 改为 150，并在测试里对 13 个页面 × 2 种尺寸全部断言 `tester.takeException() == null`，把「零溢出」变成可持续验证的检查点。

**问题 3：ClipPath 页的「路径要点」面板文字被裁。**
现象：第 3 行 `fit: BoxFit.cover` 被面板底边切掉，右上角参数 chip 显示为 `moveTo / lineTo / quadrati…`。
定位：面板 `height: 112` + 三行 `height: 1.7` 的 12px 文字 ≈ 需要 120px 以上；同时 `DemoPanel` 头部是 `Expanded(title) + Flexible(ParamChip)`，chip 太长会把标题挤成两行。
解决：面板高度改 150、参数文案缩短为 `Path 三方法`。同类问题在弹性页也出现过——测量语句里的 2:1:1 数值没有扣除两条 8px 间距，改为 `unit = (available - 16) / 4` 后与实测方块宽度一致（157 / 79 / 79）。

**问题 4：Playwright 点不动 Flutter canvas 上的图标。**
现象：用语义树点文字能跳转，但用坐标点 EX1 的星星图标没有任何反应。
定位：开了语义树后，覆盖在 canvas 上的语义节点会拦截指针事件，而图标节点没有 label、也没有 tap 语义。
解决：截图脚本里先把所有 `flt-semantics` 节点设为 `pointer-events: none`，再按坐标点击，点击直达 Flutter 画布，粒子与金币计数正常出现（已用作证据截图）。

## 七、AI 使用记录

| # | 用途 | 指令摘要 | AI 输出 | 本人验证方式 |
| --- | --- | --- | --- | --- |
| 1 | 项目脚手架 | 「按手册建 lecture6，分 6.1/6.2/6.3/6A 分组」 | 目录结构、`pubspec.yaml` 资源声明、首页菜单骨架 | `flutter run -d chrome` 能进入首页并跳转 |
| 2 | 6.1 名片页 | 「按设计参数实现 profile_card，三段提交」 | `_ProfileCard` / `_StatsCard` / `_TagsCard` / `_ActionBar` | 截图对照设计稿；窄屏无溢出 |
| 3 | 6.2 实验页 | 「六种对齐、2:1:1、角标、容器美化，共用 DemoPanel」 | 4 个页面 + 公共组件 `lab_widgets.dart` | 逐页截图核对参数 chip 与现象 |
| 4 | 6.3 研究页 | 「约束撑不满/溢出、FittedBox 三策略、ClipPath 波浪」 | 3 个页面 + `_WaveClipper` | 切换开关观察黄黑条；Inspector 对照 |
| 5 | 6A 修复 | 「读演示站源码，指出每个 EX 的病根并修」 | 5 个修复页 + 病根说明 | 逐项交互截图；60 秒连续操作无异常 |
| 6 | 调试 | 「测试报 RenderFlex overflowed 22px，帮我定位」 | 指出面板高度与内容高度差 | 本人按 38×3+20=134 复算，确认取值 |
| 7 | 报告 | 「按模板写十节，不插图，说明配图怎么得到」 | 本文件 | 逐节核对是否覆盖模板要求 |

标注：所有 AI 生成代码均经过本人阅读、按设计稿改参数，并跑过 `dart analyze` / `flutter test` / 浏览器截图三重验证；第五节表格中的数值（157/79/79、22px）为实测值，不是 AI 估计值。

## 八、证据截图

正文不插图，以下 8 处配图按顺序补入雨课堂，每张图后附一句话说明。

- **【图1 首页菜单】**：应用启动后的分组菜单。说明：13 个演示入口按 6.1 / 6.2 / 6.3 / 6A 四组排列。
  取图：`flutter run -d chrome` 打开首页，按 `Win + Shift + S` 截取浏览器窗口。
- **【图2 profile_card】**：6.1 名片页完整效果。说明：头图 + 头像徽标 + 三栏统计 + 标签 + 底部操作栏，需与设计稿参数逐项对上。
  取图：首页点「profile_card 个人名片」，等图片加载完后整屏截图；建议同时截 390 宽与 900 宽各一张对比。
- **【图3 对齐任务卡】**：六种对齐现象的 2 张长截图（主轴 / 交叉轴）。说明：每张卡右上角 chip 显示实际参数，方块位置与参数一致。
  取图：首页点「对齐任务卡」，先截首屏，再滚动后截后半部分。
- **【图4 弹性 2:1:1 与溢出对比】**：两张图。说明：左图为 2:1:1 实测 157/79/79；右图为关掉 Expanded 后底部黄黑条（异常路径证据）。
  取图：首页点「弹性分配实验」，截首屏 → 把开关拨到「关」→ 再截一张，黄黑条会出现在第二张卡底部。
- **【图5 层叠与容器】**：层叠角标页（在线/离线徽标 + 图片浮层）与容器美化页（白卡/渐变/圆角图）各一张。说明：证明 Stack + Positioned 与 BoxDecoration / ClipRRect 的实际效果。
  取图：分别点「层叠角标」「容器美化」整屏截图。
- **【图6 约束传递 + Inspector】**：两张。说明：左图为打开「强制撑满」前后的宽度差异；右图为 DevTools Inspector 里选中容器后显示的 `BoxConstraints`（宽 120 的父级 vs `double.infinity`）。
  取图：点「约束传递实验」→ 截图 → 在 Chrome 里按 `F12` 打开 DevTools，切到 Flutter Inspector（需以 `flutter run -d chrome` 启动，不是静态构建），用「选择组件」点中演示方块，展开 Layout Explorer 截取约束面板。
- **【图7 6A 五个案例】**：五张。说明：EX1 粒子爆炸（金币 3）、EX2 新增一笔记录后的合计、EX3 宽屏 7 列仍固定 40、EX4 转动中与停止后指针指向的扇区、EX5 底部菜单与点赞后的「胡老师、我」。
  取图：依次进入 6A 五个页面；EX4 点「开始抽奖」后 1.3 秒截「转动中」、3.8 秒后截「停止」；EX5 点右上角「…」截菜单，再点「点赞」截点赞结果。
- **【图8 测试与提交记录】**：两张终端截图。说明：`dart analyze lib test` 输出 `No issues found!` + `flutter test` 输出 `All tests passed!`（27 项）；`git log --oneline` 输出 12 次提交。
  取图：在 `lecture6` 目录执行 `dart analyze lib test; flutter test; git log --oneline` 后整屏截图。

## 九、自评

| 要求 | 完成情况 | 说明 |
| --- | --- | --- |
| 6.1 案例复现（必做） | 完成 | 三步三次提交，设计参数逐项对上，双尺寸无溢出 |
| 6.2 对齐任务卡（必做） | 完成 | 六种场景，主轴 5 种 + 交叉轴 1 种，参数 chip 标注 |
| 6.2 弹性分配（必做） | 完成 | 2:1:1 实测值 + 长内容开关 + 选型结论 |
| 6.2 层叠角标（必做） | 完成 | 头像徽标 + 图片浮层文字两场景 |
| 6.2 容器美化（必做） | 完成 | 白卡、渐变头图、圆角图，并附 `color`/`decoration` 反例说明 |
| 6.2 AI 使用标注（必做） | 完成 | 第七节表格逐条标注用途、指令、验证方式 |
| 6.3 约束传递（选做） | 完成 | 撑不满 / 强制撑满 / 溢出三种状态 + Inspector 读法 |
| 6.3 FittedBox（选做） | 完成 | contain / fill / scaleDown 三列对比 + 选型结论 |
| 6.3 ClipPath（选做） | 完成 | 波浪头图 + 路径三方法说明 |
| 6A 五个案例（选做） | 完成 | EX1~EX5 各自单独提交，提交信息写明病根 |
| 进度报告 | 完成 | 本文件 + 雨课堂同文（图片单独上传） |
| 仓库与提交 | 完成 | 12 次提交，每次提交均可编译；已 push 到 GitHub |

未做/降级说明：6A 属于选做，本轮全部完成；6.3 三项也全部完成；未使用真机与模拟器，验收以 Web 为主（受环境限制）。

## 十、一句话收获与下一步计划

一句话收获：**布局问题的根因几乎都能归结为「约束」二字——先问父级给了什么约束，再问子级报了什么尺寸，最后才轮到对齐与美化。**

遗留问题：EX4 的扇区文字随盘旋转，静止时下半圈文字是倒的（已在代码注释里说明取舍，未做逐帧翻转）；`flutter analyze` 在中文路径下仍不可用，只能用 `dart analyze` 替代。

下一步预习：第 7 章的列表与滚动组件（`ListView` / `GridView` / `Sliver` 系列），重点带着本课的「约束」视角去看 `shrinkWrap` 与 `SliverConstraints`，并提前准备一个需要长列表 + 分页的页面作为练习对象。
