blog
====

simple rails4 blog, it's just for study, and I plan to use it for my blog.


服务器维护
==========

/etc/init.d/blogd 已经加到 path , 除了随机启动还可以直接操作, stop 命令可能不大好使, 暂时没有调试, 可以考虑这个命令杀掉进程以后
再启动:

    ps aux | grep "Passenger" | grep -v grep | awk '{print  "kill " $2}' | sh

    /etc/init.d/blogd