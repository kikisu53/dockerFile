# dockerFile

## 建立開發環境

### 開發工具
* [Git](https://git-scm.com/)
* [GNU Make](https://www.gnu.org/software/make/)
* [Docker](https://www.docker.com/)

### 環境與權限
1. Docker：請依本機 OS 安裝 [Docker for Mac](https://docs.docker.com/docker-for-mac/install/), [Docker for Windows](https://docs.docker.com/docker-for-windows/install/) 
    * Windows 作業系統使用若同時使用 Docker for windows 及 VirtualBox 會有 Hyper-V 衝突問題。請以系統管理員開啟 CMD，並根據下列語法操作。
    ```bash
    # 使用Docker 前
    bcdedit /set hypervisorlaunchtype auto
    # 使用Vagrant 前
    bcdedit /set hypervisorlaunchtype off
    # 查看設定 
    bcdedit
    ```

2. 本機設定 github oauth
    a. 產生 [GitHub Access Token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)。
    b. 按以下方式設定
    ```bash
    # 設定
    $ composer config -g github-oauth.github.com <access_token>

    # 檢查
    $ composer config -gl | grep github-oauth.github.com
    [github-oauth.github.com] <access_token>
    ```

### 第一次建置步驟
1. 使用 SSH clone repo： `git clone git@github.com:kikisu53/dockerFile.git`

2. 建立 docker image： `make build` 

3. 啟動 docker container： `make run` 
    * 如要關閉，可使用 exit 指令關閉 container 。

4. composer 安裝套件： container 內輸入指令 `make deps`

5. 啟動 php 內置伺服器： container 內輸入指令 `make server` 
    * 在 http://localhost:8080 可以看到 `Hello World!` 。
    * 如要關閉，可使用 ctrl+C 關閉。

> 3 ~ 5 可透過 `make start` 完成。

### make 指令
1. build docker image

    ```bash
    # 建立新的 image
    make build
    # 移除 image，如果有開 docker container，需先透過 make stop 關閉 container
    make destroy
    # 重建 image
    make rebuild
    ```

2. docker container

    ```bash
    # 執行 container
    make run
    # 關閉 container 並刪除 container
    make stop
    # shell 進 container
    make shell
    # 執行 container ，包含 composer install 和建立 php 內置伺服器，在 http://localhost:8080 可以看到 `Hello World!` ，ctrl+C 可關閉伺服器和 container。
    make start
    # 執行 container ，並在 container 裡面下 make all 的指令，跑完關閉 container 。
    make docker-tests
    ```

3. 其他可在 container 內運行指令

    ```bash
    # composer install
    make deps
    # 啟動 php 內置伺服器，在 http://localhost:8080 可以看到 `Hello World!` ，ctrl+C 可關閉伺服器。
    make server
    # 測試：測試文件輸出在 build 資料夾。
    make tests
    # php 格式檢查
    make phpcs
    # php 代碼靜態分析
    make phpstan
    # php 格式校正
    make phpcbf
    # 完整測試
    make all
    ```