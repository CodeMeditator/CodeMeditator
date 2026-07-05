# OpenClaw 每日打卡自动化

把打卡图片发到 OpenClaw 后，让它更新 [CodeMeditator profile](https://github.com/CodeMeditator) 仓库。

## 仓库路径

本地 clone 路径（OpenClaw 需要能读写）：

```text
/Users/richard/Assist/GitHub/GitHub_Profile
```

远程仓库：`https://github.com/CodeMeditator/CodeMeditator`

## OpenClaw 配置

1. 启用 GitHub skill，并设置 `GITHUB_TOKEN`（需 `Contents: Read and write` 权限）。
2. 确保本机已 `gh auth login` 或 token 可用。

`~/.openclaw/openclaw.json` 示例：

```json
{
  "skills": {
    "entries": {
      "github": {
        "enabled": true,
        "apiKey": {
          "source": "env",
          "id": "GITHUB_TOKEN"
        }
      }
    }
  }
}
```

## Agent 指令（复制到 OpenClaw SOUL / 自定义 skill）

```text
当我发送「打卡」并附带一张图片时：

1. 把图片保存到临时路径
2. 在 /Users/richard/Assist/GitHub/GitHub_Profile 执行：
   ./scripts/update-checkin.sh /path/to/image.png --push
3. 成功后回复 GitHub 主页链接：https://github.com/CodeMeditator
4. 若 push 失败，把 git 错误信息告诉我
```

## 手动更新

```bash
cd /Users/richard/Assist/GitHub/GitHub_Profile
./scripts/update-checkin.sh ~/Downloads/checkin.png --push
```

## 文件说明

| 文件 | 说明 |
|------|------|
| `assets/checkin/latest.png` | README 固定引用，始终是最新一张 |
| `assets/checkin/YYYY-MM-DD.png` | 按日期归档 |
| `assets/checkin/placeholder.svg` | 占位图，首次打卡前显示 |
| `scripts/update-checkin.sh` | 更新图片、README 缓存参数并 commit |
