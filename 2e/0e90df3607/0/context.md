# Session Context

## User Prompts

### Prompt 1

看看现在下载量

### Prompt 2

看看现在下载量

### Prompt 3

现在呢

### Prompt 4

Minion Mind 下载统计                                                                                                                                                   
                                                                                                                                                                         
  ┌───────────────────────────┬────────┐                                          ...

### Prompt 5

?per_page=100. 那以后更多,不是慢慢都被挤出去,需要想办法解决一下

### Prompt 6

ok.可是随着version越来越多,这是不是有问题?还是github 一直所有releases metadata都存?

### Prompt 7

方案 B：本地保存历史快照
  把累计下载量存到本地文件，每次只增量更新。是的,只能这样. 旧版本删除肯定不行啊,那是我们的tracking数据啊

### Prompt 8

需要把 stats_snapshot.json 提交到 git 吗,最好不要,这是public repo,我并不想别人看,gitignore吧

### Prompt 9

git push把.对,如果stats_snapshot.json不存在,stats.sh可以创建它

