# 将 sql-exercise 推送到 GitHub

本项目已经初始化为一个本地 Git 仓库，默认分支为 `main`，已包含一次提交，远程 `origin` 已预设为：

`https://github.com/1920463940/sql-exercise.git`

## 一、在 GitHub 创建空仓库

1. 登录 GitHub，打开 https://github.com/new 。
2. Repository name 填写 `sql-exercise`。
3. 选择公开或私有（课程作业分享通常可选公开）。
4. **不要勾选** `Add a README file`、`.gitignore` 或 License，因为这些文件已经在本地仓库中。
5. 点击 Create repository。

## 二、在 Windows 中推送

1. 解压整个 `sql-exercise-git-ready.zip`，不要漏掉其中的隐藏文件夹 `.git`。
2. 在解压出的 `sql-exercise` 目录打开 PowerShell 或 Git Bash。
3. 执行：

```bash
git remote -v
git status
git push -u origin main
```

4. 如果弹出 GitHub 授权界面，按提示使用本人 GitHub 账号授权。
5. 刷新 https://github.com/1920463940/sql-exercise ，检查是否显示 README、images 和 sql。

> 如果 `git remote -v` 中的 GitHub 账号不是你的目标账号，则修改：
>
> `git remote set-url origin https://github.com/<你的用户名>/sql-exercise.git`
>
> 切勿在仓库里上传数据库密码、私人访问令牌或真实学生隐私数据。

## 三、之后如何更新仓库

```bash
git add .
git commit -m "Update SQL exercise"
git push
```

运行上述命令前，请先在电脑安装 Git：https://git-scm.com/downloads 。
