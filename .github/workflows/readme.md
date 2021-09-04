# A sample workflow file

[使用 GitHub Actions 实现博客自动化部署](https://frostming.com/2020/04-26/github-actions-deploy/)
```
name: Deploy site files

on:
  push:
    branches:
      - master # 只在master上push触发部署
    paths-ignore: # 下列文件的变更不触发部署，可以自行添加
      - README.md
      - LICENSE

jobs:
  deploy:
    runs-on: ubuntu-latest # 使用ubuntu系统镜像运行自动化脚本

    steps: # 自动化步骤
      - uses: actions/checkout@v2 # 第一步，下载代码仓库

      - name: Deploy to Server # 第二步，rsync推文件
        uses: AEnterprise/rsync-deploy@v1.0 # 使用别人包装好的步骤镜像
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }} # 引用配置，SSH私钥
          ARGS: -avz --delete --exclude='*.pyc' # rsync参数，排除.pyc文件
          SERVER_PORT: "22" # SSH端口
          FOLDER: ./ # 要推送的文件夹，路径相对于代码仓库的根目录
          SERVER_IP: ${{ secrets.SSH_HOST }} # 引用配置，服务器的host名（IP或者域名domain.com）
          USERNAME: ${{ secrets.SSH_USERNAME }} # 引用配置，服务器登录名
          SERVER_DESTINATION: /home/fming/mysite/ # 部署到目标文件夹
      - name: Restart server # 第三步，重启服务
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SSH_HOST }} # 下面三个配置与上一步类似
          username: ${{ secrets.SSH_USERNAME }}
          key: ${{ secrets.DEPLOY_KEY }}
          # 重启的脚本，根据自身情况做相应改动，一般要做的是migrate数据库以及重启服务器
          script: |
            cd /home/fming/mysite/
            python manage.py migrate
            supervisorctl restart web
```

# Another sample

[Workflow syntax for GitHub Actions](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)

[使用 GitHub Action 持续集成你的博客](https://blog.xiaohei.im/posts/github-action-guide/)

```
name: github pages # 工作流的名称

# 触发工作流的事件 Event 下面设置的是当 push 到 source 分支后触发
# 其他的事件还有：pull_request/page_build/release
# 可参考：https://help.github.com/en/actions/reference/events-that-trigger-workflows
on:	
  push:
    branches:
    - source

# jobs 即工作流中的执行任务
jobs:
  build-deploy: # job-id
    runs-on: ubuntu-18.04 # 容器环境
    # needs: other-job 如果有依赖其他的 job 可以如此配置
    
    # 任务步骤集合
    steps:
    - name: Checkout	# 步骤名称
      uses: actions/checkout@v2	# 引用可重用的 actions，比如这个就是 GitHub 官方的用于拉取代码的actions `@` 后面可以跟指定的分支或者 release 的版本或者特定的commit
      with:	# 当前 actions 的一些配置
        submodules: true # 如果项目有依赖 Git 子项目时可以设为 true，拉取的时候会一并拉取下来

    - name: Setup Hugo
      uses: peaceiris/actions-hugo@v2	# 这也是一个开源的 actions 用于安装 Hugo
      with:
        hugo-version: 'latest'
        # extended: true

    - name: Build
      run: hugo --minify # 一个 step 也可以直接用 run 执行命令。如果有多个命令可以如下使用
      #run: |
    		#npm ci
    		#npm run build

    - name: Deploy
      uses: peaceiris/actions-gh-pages@v3 # 开源 actions 用于部署
      with:
        github_token: ${{ secrets.GITHUB_TOKEN}} # GitHub 读写仓库的权限token，自动生成无需关心
        publish_branch: master
```

# run a script

To be more explicit, you can write ./.github/script.sh.

If you want to know the full path where the working copy resides in the runner, then you can do run: pwd which will print the working directory.

The absolute path should be /home/runner/work/{repo-name}/{repo-name}/.github/script.sh, so this should also work:

- run: |
    # make file runnable, might not be necessary
    chmod +x "${GITHUB_WORKSPACE}/.github/script.sh"

    # run script
    "${GITHUB_WORKSPACE}/.github/script.sh"
    # or
    "${{ format('{0}/.github/script.sh', github.workspace) }}"


# File systems
https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners

GitHub executes actions and shell commands in specific directories on the virtual machine. The file paths on virtual machines are not static. Use the environment variables GitHub provides to construct file paths for the home, workspace, and workflow directories.
Directory	Environment variable	Description
home	HOME	Contains user-related data. For example, this directory could contain credentials from a login attempt.
workspace	GITHUB_WORKSPACE	Actions and shell commands execute in this directory. An action can modify the contents of this directory, which subsequent actions can access.
workflow/event.json	GITHUB_EVENT_PATH	The POST payload of the webhook event that triggered the workflow. GitHub rewrites this each time an action executes to isolate file content between actions.

For a list of the environment variables GitHub creates for each workflow, see "Using environment variables."
Docker container filesystem

Actions that run in Docker containers have static directories under the /github path. However, we strongly recommend using the default environment variables to construct file paths in Docker containers.

GitHub reserves the /github path prefix and creates three directories for actions.

    /github/home
    /github/workspace - Note: GitHub Actions must be run by the default Docker user (root). Ensure your Dockerfile does not set the USER instruction, otherwise you will not be able to access GITHUB_WORKSPACE.
    /github/workflow

