# 璀璨圣诞树 · Merry Christmas

一个基于 Three.js 的 WebGL 3D 圣诞树交互场景：可旋转缩放、星光漂浮、礼物盒与彩球装饰、可上传回忆相册，并支持通过 MediaPipe Hands 用手势控制场景。
# 演示站:https://qjskjktafiyc.sealosgzg.site
# 效果
![璀璨圣诞树](http://fox-reg.imagency.cn/a/202611/22/6b02523c1f498.png)

项目是**已构建好的纯静态站点**（Vite 打包产物），没有源码依赖，也不需要 `npm install`，用任意静态文件服务器或 Docker 即可运行。

[![Docker Pulls](https://img.shields.io/docker/pulls/lurendev/merry-christmas)](https://hub.docker.com/r/lurendev/merry-christmas)

## 快速开始

方式一，Docker（推荐）：

```powershell
docker run -d --name merry-christmas -p 8080:80 lurendev/merry-christmas:0.1
```

打开 <http://localhost:8080/index.html>。

方式二，本地静态服务器（需要 Python 3）：

```powershell
# 在项目根目录执行
python -m http.server 8000 --bind 127.0.0.1
```

打开 <http://127.0.0.1:8000/index.html>。

## 部署到 Sealos

镜像已发布，Sealos 直接拉取即可，无需在云端重新构建，也不需要写 YAML。用【应用管理】(App Launchpad) 几步就能上线。

1. 登录 [Sealos Cloud](https://cloud.sealos.run)（或所在区域，如 `hzh.sealos.run`、`bja.sealos.run`）
2. 打开【应用管理】→【新建应用】
3. 按下面填写：

| 字段 | 值 |
| --- | --- |
| 应用名称 | `merry-christmas` |
| 镜像源 | 公开 |
| 镜像名 | `lurendev/merry-christmas:0.1` |
| 资源配置 | 固定实例 |
| CPU | `0.1` |
| 内存 | `256 Mi` |
| 容器暴露端口 | `80` |
| 公网访问 | 开启 |

4. 点击【部署】
5. 部署完成后在新页面能看到「公网访问」地址，点开就能访问页面

Sealos 会自动签发 HTTPS 证书，而手势识别依赖安全上下文，因此该域名可直接使用摄像头，无需额外配置。

部署后验证：

- 首页能正常渲染 3D 圣诞树
- F12 → Network 中 `hands_solution_simd_wasm_bin.wasm` 返回 `application/wasm`（镜像内 Nginx 已配好 MIME）
- 点「手势控制」能正常弹出摄像头授权

注意事项：

- **拉取镜像超时**：国内节点拉 Docker Hub 可能限速，可把镜像另推一份到阿里云 ACR 等国内仓库，再将镜像名改为该地址
- **计费**：Sealos Cloud 按资源用量计费，保持 `0.1 核 / 256 Mi` 成本很低；不对外展示时可缩容到 0 副本
- **更新版本**：应用详情 →【变更】改镜像 tag 即可滚动更新，无需删除应用重建
- **必须用 HTTPS 域名访问**：非 HTTPS 下浏览器会禁用摄像头，手势功能不可用

## 部署（其他静态托管）

整个目录就是静态产物，可原样放到任意静态托管（Nginx、GitHub Pages、对象存储等）的根目录下，也可直接用本仓库的 Docker 镜像部署。注意保持 `assets/`、`audio/`、`mediapipe/` 与 `index.html` 的相对位置不变；如需在公网使用摄像头功能，站点必须为 HTTPS。

## 目录结构

```
christmas-tree/
├── index.html                  # 入口页面
├── Dockerfile                  # Nginx 静态托管镜像
├── .dockerignore
├── README.md
├── assets/
│   ├── index-CZPyPNXc.js       # 打包后的应用逻辑（Three.js 场景 / UI）
│   └── index-BeE7YxDE.css      # 打包后的样式
├── audio/
│   └── christmas-by-ikson.mp3  # 背景音乐
└── mediapipe/                  # MediaPipe Hands 手势识别运行时（wasm + 模型）
    ├── hands/
    ├── camera_utils/
    ├── control_utils/
    └── drawing_utils/
```

## 环境要求

- 浏览器：Chrome / Edge 等支持 WebGL2 与 ES Module 的现代浏览器
- 本地起服务：Python 3（任意版本均可）或 Docker

## 本地运行（Python）

在项目根目录执行：

```powershell
python -m http.server 8000 --bind 127.0.0.1
```

Mac / Linux：

```bash
python3 -m http.server 8000 --bind 127.0.0.1
```

然后打开 <http://127.0.0.1:8000/index.html>。

停止服务：在运行窗口按 `Ctrl + C`。

> **不要直接双击 index.html 用 `file://` 打开。**
> 页面使用 ES Module、MediaPipe 的 `.wasm/.tflite` 资源以及摄像头接口，`file://` 下会被浏览器的跨域与安全策略拦截。必须通过 `http://`（`localhost` / `127.0.0.1` 属于安全上下文，摄像头可用）。

## Docker

镜像已发布到 Docker Hub：[lurendev/merry-christmas](https://hub.docker.com/r/lurendev/merry-christmas)

| 项目 | 值 |
| --- | --- |
| 镜像 | `lurendev/merry-christmas:0.1` |
| 基础镜像 | `nginx:1.27-alpine` |
| Digest | `sha256:d34e520d2e7b4a61434ab4c2019aa4e5ff2df325ea194fa120152df44fc65ba8` |
| 本地镜像大小 | 123 MB（含 30 MB 静态产物） |

```powershell
# 运行
docker run -d --name merry-christmas -p 8080:80 lurendev/merry-christmas:0.1

# 停止 / 删除
docker stop merry-christmas
docker rm merry-christmas
```

容器内 Nginx 已完成以下配置，无需额外处理：

- MIME 映射：`application/wasm`、`text/javascript`、`audio/mpeg`，以及 `.tflite` / `.data` / `.binarypb`（`application/octet-stream`），保证 MediaPipe 资源可正常加载
- `try_files $uri $uri/ /index.html` 兜底，`autoindex off`
- `HEALTHCHECK`：每 30s 请求 `/index.html`

本地重新构建并推送：

```powershell
docker login
docker build -t lurendev/merry-christmas:0.1 .
docker push lurendev/merry-christmas:0.1
```

## 功能说明

| 功能 | 说明 |
| --- | --- |
| 3D 场景 | 拖动旋转、滚轮缩放；按住鼠标/触摸可让星光绽放 |
| 展示模式 | 可切换「圣诞树」与「星光漂浮」两种模式 |
| 圣诞布置 | 调整星光粒子数量、主色、点缀色，开关礼物盒与彩球 |
| 回忆相册 | 上传照片（仅保存在本机浏览器 localStorage/IndexedDB，不上传服务器），悬停可删除 |
| 音乐 | 内置 `christmas-by-ikson.mp3`，可播放/暂停，也可上传本地音乐 |
| 手势控制 | 开启「手势控制」需授权摄像头，由 MediaPipe Hands 识别手势；首次加载手势引擎会读取 `mediapipe/` 下的模型文件 |

## 常见问题

- **首次进入没有声音**：现代浏览器禁止自动播放，页面会提示「点击任意处进入并开启音乐」，点击后即可播放。
- **手势控制不可用**：需允许摄像头权限，且必须通过 `http://localhost` / `http://127.0.0.1` 访问；若仍失败，检查 `mediapipe/` 目录是否完整。
- **控制台出现 `THREE.WebGLRenderer: A WebGL context could not be created`**：构建产物中手势画面复用了同一 canvas 时的已知告警，不影响 3D 场景正常渲染与交互。
- **端口被占用**：把 `8000` / `8080` 换成其他端口后重新启动，并同步修改访问地址。
- **`file://` 打开白屏**：见上文，必须通过 HTTP 访问。

### 手势能出画面但识别不到（首次加载）

**现象**：点开「手势控制」后右下角小窗能看到摄像头人像，但没有绿色骨架和红点，挥手也没反应；刷新或重试一次后又正常了。

**原因**：手势引擎是**懒加载**——只有在点开「手势控制」的那一刻才开始下载模型资源，合计约 16 MB：

| 资源 | 大小 |
| --- | --- |
| `mediapipe/hands/hands_solution_simd_wasm_bin.wasm` | 6.0 MB |
| `mediapipe/hands/hand_landmark_full.tflite` | 5.5 MB |
| `mediapipe/hands/hands_solution_packed_assets.data` | 4.3 MB |

其中任意一个文件下载中断（网络抖动、代理拦截、TLS 连接被重置），推理就不会开始。此时摄像头画面照常显示（它由 `react-webcam` 单独渲染，与手势引擎无关），页面主体也能正常显示（主 JS 已缓存），所以表现成「有画面、没骨架」。

**判断方法**：F12 → Console 执行 `JSON.stringify(window.__gestureDiag)`：

| 结果 | 含义 | 处理 |
| --- | --- | --- |
| `sendErrors > 0` 且 `results = 0` | 模型资源没下载成功 | 刷新页面重试，换稳定网络/代理 |
| `results > 0` 且 `noHand ≈ results` | 模型在跑但没检测到手 | 靠近镜头、正对光源、手掌朝向摄像头 |
| `frames = 0` | 取帧循环没启动 | 关闭再重新开启「手势控制」 |

此外可看 Console 是否有 `Failed to initialize MediaPipe` 或 `hands.send() failed:` 红色报错。

**建议**：首次打开页面时先等加载完再点手势控制；抓包确认 `mediapipe/` 下 3 个大文件是否 200 返回。想彻底消除首次等待，需要改源码做模型预加载，属于额外改造。
