[SVN菜鸟教程](https://www.runoob.com/svn/svn-intro.html)     

[W3C SVN教程](https://www.w3cschool.cn/svn/)

[**Git与SVN对比**](https://www.cnblogs.com/WindrunnerMax/p/14171924.html)

# git与SVN对比
SVN与Git的主要区别如下：

1. **架构模型**  
SVN是**集中式版本控制系统**，依赖中央服务器管理所有版本历史，用户需联网操作[[3]][[4]][[5]][[7]]。  
Git是**分布式版本控制系统**，每个用户拥有完整的本地仓库副本，可离线操作并同步到远程仓库[[3]][[5]][[10]]。
2. **分支与标签管理**  
SVN通过目录权限限制模拟分支和标签（如`/trunk`、`/branches`、`/tags`），但分支操作较笨重[[2]][[9]]。  
Git原生支持轻量级分支和标签，通过元数据管理，切换分支和合并代码更高效[[2]][[9]][[10]]。
3. **存储方式与数据完整性**  
SVN按文件存储版本历史，每个文件有独立版本号，但仓库易因权限或操作失误损坏[[9]][[10]]。  
Git以元数据（快照）形式存储，所有变更记录在`.git`目录中，并通过SHA-1哈希保证内容完整性[[9]][[10]]。
4. **适用场景**  
SVN适合**集中化团队协作**（如企业内部项目），注重权限管理和简单易用[[1]][[4]]。  
Git适合**分布式开发**（如开源项目），强调高效协作、分支管理和离线操作[[1]][[4]][[10]]。
5. **版本号机制**  
SVN使用**全局递增版本号**追踪变更[[9]]。  
Git无全局版本号，通过提交哈希值（commit hash）标识唯一版本[[9]]。

**总结**：Git在灵活性、数据安全性和离线能力上更优，适合复杂协作；SVN则因集中化架构更易上手，适合权限明确的团队。

| **<font style="color:rgb(49, 70, 89);">差异</font>** | **<font style="color:rgb(49, 70, 89);">SVN</font>** | **<font style="color:rgb(49, 70, 89);">Git</font>** |
| :--- | :--- | :--- |
| <font style="color:rgb(49, 70, 89);">系统特点</font> | <font style="color:rgb(49, 70, 89);">1. 集中式版本控制系统，文档管理很方便。   </font><font style="color:rgb(49, 70, 89);">2. 企业内部并行集中开发   </font><font style="color:rgb(49, 70, 89);">3. </font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">windows</font>`<font style="color:rgb(49, 70, 89);">系统上开发推荐使用   </font><font style="color:rgb(49, 70, 89);">4. 克隆一个拥有将近一万个提交</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">commit</font>`<font style="color:rgb(49, 70, 89);">，五个分支，每个分支有大约</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">1500</font>`<font style="color:rgb(49, 70, 89);">个文件，用时将近一个小时</font> | <font style="color:rgb(49, 70, 89);">1. 分布式系统，代码管理很方便。   </font><font style="color:rgb(49, 70, 89);">2. 开源项目开发。   </font><font style="color:rgb(49, 70, 89);">3. </font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">Mac</font>`<font style="color:rgb(49, 70, 89);">、</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">Linux</font>`<font style="color:rgb(49, 70, 89);">系统上开发推荐使用。   </font><font style="color:rgb(49, 70, 89);">4. 克隆一个拥有将近一万个提交</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">commit</font>`<font style="color:rgb(49, 70, 89);">、五个分支、每个分支有大约</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">1500</font>`<br/><font style="color:rgb(49, 70, 89);">个文件，用时</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">1</font>`<font style="color:rgb(49, 70, 89);">分钟。</font> |
| <font style="color:rgb(49, 70, 89);">灵活性</font> | <font style="color:rgb(49, 70, 89);">1. 搭载</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">SVN</font>`<font style="color:rgb(49, 70, 89);">的服务器如果出现故障，就无法与之交互。   </font><font style="color:rgb(49, 70, 89);">2. 所有的</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">SVN</font>`<font style="color:rgb(49, 70, 89);">操作都需要中央仓库交互，例如拉分支，看日志等。</font> | <font style="color:rgb(49, 70, 89);">1. 可以单机操作，</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">Git</font>`<font style="color:rgb(49, 70, 89);">服务器故障也可以在本地</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">Git</font>`<font style="color:rgb(49, 70, 89);">仓库工作。   </font><font style="color:rgb(49, 70, 89);">2. 除了</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">push</font>`<font style="color:rgb(49, 70, 89);">和</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">pull</font>`<font style="color:rgb(49, 70, 89);">或</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">fetch</font>`<font style="color:rgb(49, 70, 89);">操作，其他都可以在本地操作。   </font><font style="color:rgb(49, 70, 89);">3. 根据自己开发任务任意在本地创建分支。   </font><font style="color:rgb(49, 70, 89);">4. 日志都是在本地查看，效率较高。</font> |
| <font style="color:rgb(49, 70, 89);">安全性</font> | <font style="color:rgb(49, 70, 89);">较差，定期备份，并且是整个</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">SVN</font>`<font style="color:rgb(49, 70, 89);">都得备份。</font> | <font style="color:rgb(49, 70, 89);">较高，每个开发者的本地就是一套完整版本库，记录着版本库的所有信息。</font> |
| <font style="color:rgb(49, 70, 89);">分支方面</font> | <font style="color:rgb(49, 70, 89);">1. 拉分支更像是</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">copy</font>`<font style="color:rgb(49, 70, 89);">一个路径。   </font><font style="color:rgb(49, 70, 89);">2. 可针对任何子目录进行</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">branch</font>`<font style="color:rgb(49, 70, 89);">。   </font><font style="color:rgb(49, 70, 89);">3. 拉分支的时间较慢，因为拉分支相当于</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">copy</font>`<font style="color:rgb(49, 70, 89);">。   </font><font style="color:rgb(49, 70, 89);">4.创建完分支后，影响全部成员，每个人都会拥有这个分支。   </font><font style="color:rgb(49, 70, 89);">5.多分支并行开发较重，工作较多而且繁琐。</font> | <font style="color:rgb(49, 70, 89);">1. 我可以在</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">Git</font>`<font style="color:rgb(49, 70, 89);">的任意一个提交点</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">commit point</font>`<font style="color:rgb(49, 70, 89);">开启分支。   </font><font style="color:rgb(49, 70, 89);">2. 拉分支时间较快，因为拉分支只是创建文件的指针和</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">HEAD</font>`<font style="color:rgb(49, 70, 89);">。   </font><font style="color:rgb(49, 70, 89);">3. 自己本地创建的分支不会影响其他人。   </font><font style="color:rgb(49, 70, 89);">4. 比较适合多分支并行开发。   </font><font style="color:rgb(49, 70, 89);">5. </font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">Git checkout hash</font>`<font style="color:rgb(49, 70, 89);">切回之前的版本，无需版本回退。   </font><font style="color:rgb(49, 70, 89);">6. 强大的</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">cherry-pick</font>`<font style="color:rgb(49, 70, 89);">。</font> |
| <font style="color:rgb(49, 70, 89);">工作流程</font> | <font style="color:rgb(49, 70, 89);">1. 每次更改文件之前都得</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">update</font>`<font style="color:rgb(49, 70, 89);">操作，有的时候修改过程中这个文件有更新，</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">commit</font>`<font style="color:rgb(49, 70, 89);">不会成功。   </font><font style="color:rgb(49, 70, 89);">2. 有冲突，会打断提交动作，冲突解决是一个提交速度的竞赛：手快者，先提交，平安无事；手慢者，后提交，可能遇到麻烦的冲突解决。</font> | <font style="color:rgb(49, 70, 89);">1. 开始工作前进行</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">fetch</font>`<font style="color:rgb(49, 70, 89);">操作，完成开发工作后</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">push</font>`<font style="color:rgb(49, 70, 89);">操作，有冲突解决冲突。   </font><font style="color:rgb(49, 70, 89);">2. </font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">Git</font>`<font style="color:rgb(49, 70, 89);">的提交过程不会被打断，有冲突会标记冲突文件。   </font><font style="color:rgb(49, 70, 89);">3. </font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">Gitflow</font>`<font style="color:rgb(49, 70, 89);">经典流程。</font> |
| <font style="color:rgb(49, 70, 89);">内容管理</font> | `<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">SVN</font>`<font style="color:rgb(49, 70, 89);">对中文支持好，操作简单。</font> | <font style="color:rgb(49, 70, 89);">对程序的源代码管理方便，代码库占用的空间少，易于分支化管理。</font> |
| <font style="color:rgb(49, 70, 89);">学习成本</font> | <font style="color:rgb(49, 70, 89);">使用起来更方便，</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">SVN</font>`<font style="color:rgb(49, 70, 89);">对中文支持好，操作简单。</font> | <font style="color:rgb(49, 70, 89);">更在乎效率而不是易用性，成本较高，有很多独有的命令如</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">rebase</font>`<font style="color:rgb(49, 70, 89);">、远程仓库交互的命令等等。</font> |
| <font style="color:rgb(49, 70, 89);">权限管理</font> | `<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">SVN</font>`<font style="color:rgb(49, 70, 89);">的权限管理相当严格，可以按组、个人针对某个子目录的权限控制，每个目录下都会有个</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">.SVN</font>`<font style="color:rgb(49, 70, 89);">的隐藏文件。</font> | `<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">Git</font>`<font style="color:rgb(49, 70, 89);">没有严格的权限管理控制，只有账号角色划分。</font> |
| <font style="color:rgb(49, 70, 89);">管理平台</font> | <font style="color:rgb(49, 70, 89);">有功能非常完善的插件。</font> | <font style="color:rgb(49, 70, 89);">除功能插件外，还有</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">Gitlab</font>`<font style="color:rgb(49, 70, 89);">、</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">Gerrit</font>`<font style="color:rgb(49, 70, 89);">、</font>`<font style="color:rgb(49, 70, 89);background-color:rgb(242, 244, 245) !important;">Github</font>`<font style="color:rgb(49, 70, 89);">等。</font> |


以下是基于知识库内容整理的SVN快速使用指南，涵盖安装到基本操作全流程：

---

# SVN 使用
### **一、安装与配置**
1. **服务端安装**  
需部署SVN服务器（如VisualSVN Server），配置仓库路径及用户权限[[5]][[6]]。
2. **客户端安装**  
推荐安装TortoiseSVN（Windows）或命令行工具，安装后右键菜单集成SVN操作[[5]][[8]]。

---

### **二、核心操作流程**
#### **1. 检出（Checkout）仓库**
+ **步骤**：右键 → `SVN Checkout` → 输入仓库URL（如`svn://10.0.4.17/runoob01`）→ 选择本地路径 → 完成检出[[3]][[8]]。  
+ **作用**：将远程仓库代码同步到本地，生成`.svn`隐藏目录记录版本信息[[9]]。

#### **2. 日常操作**
+ **新增/修改文件**  
    - 右键文件 → `Add`（新增文件需标记）→ `Commit`提交并填写日志[[2]][[4]]。
+ **更新（Update）**  
    - 右键目录 → `SVN Update`同步服务器最新代码，避免冲突[[2]][[7]]。
+ **提交（Commit）**  
    - 修改后右键 → `SVN Commit` → 填写变更说明 → 提交到服务器[[4]][[7]]。

#### **3. 分支与合并**
+ **检出分支**：通过仓库URL指定分支路径（如`/branches/feature-01`）检出[[5]]。  
+ **合并代码**：右键 → `Merge` → 选择合并类型（如合并分支到主干）→ 解决冲突后提交[[5]]。

---

### **三、进阶功能**
+ **查看日志**：右键 → `Show Log` → 查看提交记录、版本差异[[4]][[7]]。  
+ **版本回退**：在日志中右键某版本 → `Revert to this revision`恢复旧版[[9]]。  
+ **冲突解决**：更新时若冲突，需手动编辑文件 → 标记为`Resolved`后提交[[7]]。

---

### **四、注意事项**
+ 提交前务必先`Update`，减少冲突概率[[7]]。  
+ 敏感操作（如删除文件）需通过SVN命令执行，避免直接修改文件系统[[9]]。  
+ 使用TortoiseSVN时，图标覆盖可直观显示文件状态（修改、冲突等）[[8]]。

---

**附：常用命令行参考**  

```bash
svn checkout <URL>        # 检出仓库
svn add <file>            # 添加文件
svn commit -m "说明"      # 提交变更
svn update                # 更新代码
svn log                   # 查看提交日志
```

通过以上步骤，可快速掌握SVN核心用法。更多细节可参考官方文档或知识库链接[[1]][[2]][[3]]。

