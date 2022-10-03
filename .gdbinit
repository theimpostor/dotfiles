# set pathname-substitutions /opt/app-root/src/rocksdb-6.2.4 /local/home/shoda/rocksdb-6.2.4

set pagination off

set history save on

# newer gcc only:
# set history size unlimited
# set history remove-duplicates unlimited

set print pretty on
set print object on
set print vtbl on
set print array on

# warning: File "/usr/lib64/libthread_db-1.0.so" auto-loading has been declined by your `auto-load safe-path' set to "$debugdir:$datadir/auto-load:/usr/lib/golang/src/runtime/runtime-gdb.py".
# To enable execution of this file add
# 	add-auto-load-safe-path /usr/lib64/libthread_db-1.0.so
# line to your configuration file "/rv/home/shoda/.gdbinit".
# To completely disable this security protection add
set auto-load safe-path /

