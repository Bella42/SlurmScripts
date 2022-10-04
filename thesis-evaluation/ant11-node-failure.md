2022-10-04 11:05:46 564 [Warning] Aborted connection 564 to db: 'julea_db' user: 'julea_user' host: '10.61.12.15' (Got an error reading communication packets)                                                     
                                                                                                                                                                                                                   
Status information:                                                                                                                                                                                                
                                                                                                                                                                                                                   
Current dir: /var/lib/mysql/                                                                                                                                                                                       
Running threads: 1  Cached threads: 0  Stack size: 299008                                                                                                                                                          
                                                                                                                                                                                                                   
Key caches:                                                                                                                                                                                                        
default                                                                                                                                                                                                            
Buffer_size:     134217728                                                                                                                                                                                         
Block_size:           1024                                                                                                                                                                                         
Division_limit:        100                                                                                                                                                                                         
Age_threshold:         300                                                                                                                                                                                         
Partitions:              0                                                                                                                                                                                         
blocks used:             0                                                                                                                                                                                         
not flushed:             0                                                                                                                                                                                         
w_requests:              0                                                                                                                                                                                         
writes:                  0                                                                                                                                                                                         
r_requests:              0                                                                                                                                                                                         
reads:                   0                                                                                                                                                                                         
                                                                                                                                                                                                                   
                                                                                                                                                                                                                   
handler status:                                                                                                                                                                                                    
read_key:     21460237                                                                                                                                                                                             
read_next:  4381191253                                                                                                                                                                                             
read_rnd      21916791                                                                                                                                                                                             
read_first:          3                                                                                                                                                                                             
write:           56468                                                                                                                                                                                             
delete               0                                                                                                                                                                                             
update:           1008                                                                                                                                                                                             
                                                                                                                                                                                                                   
Table status:                                                                                                                                                                                                      
Opened tables:        313                                                                                                                                                                                          
Open tables:          279                                                                                                                                                                                          
Open files:            29                                                                                                                                                                                          
Open streams:           4                                                                                                                                                                                          
                                                                                                                                                                                                                   
Alarm status:                                                                                                                                                                                                      
Active alarms:   0                                                                                                                                                                                                 
Max used alarms: 0                                                                                                                                                                                                 
Next alarm time: 0                                                                                                                                                                                                 
**                                                                                                                                                                                                                 
JULEA:ERROR:../backend/object/posix.c:519:backend_fini: assertion failed: (g_hash_table_size(jd_backend_file_cache) == 0)
Bail out! JULEA:ERROR:../backend/object/posix.c:519:backend_fini: assertion failed: (g_hash_table_size(jd_backend_file_cache) == 0)                                                                                
                                                                                                                                                                                                                   
Memory status:
Non-mmapped space allocated from system: 90050560
Number of free chunks:                   4030
Number of fastbin blocks:                1035
Number of mmapped regions:               8
Space in mmapped regions:                41033728
Maximum total allocated space:           0
Space available in freed fastbin blocks: 91760
Total allocated space:                   27266560
Total free space:                        62784000
Top-most, releasable space:              130832
Estimated memory (with thread stack):    131383296
Global memory allocated by server:       48070480
Memory allocated by threads:             45136



Events status:
LLA = Last Locked At  LUA = Last Unlocked At
WOC = Waiting On Condition  DL = Data Locked

Event scheduler status:
State      : INITIALIZED
Thread id  : 0
LLA        : n/a:0
LUA        : n/a:0
WOC        : NO
Workers    : 0
Executed   : 0
Data locked: NO

Event queue status:
Element count   : 0
Data locked     : NO
Attempting lock : NO
LLA             : init_queue:141
LUA             : init_queue:151
WOC             : NO
Next activation : never
2022-10-04 12:59:28 0 [Note] mariadbd (initiated by: unknown): Normal shutdown
2022-10-04 12:59:28 0 [Note] InnoDB: FTS optimize thread exiting.
2022-10-04 12:59:28 0 [Note] InnoDB: Starting shutdown...
2022-10-04 12:59:28 0 [Note] InnoDB: Dumping buffer pool(s) to /var/lib/mysql/ib_buffer_pool
2022-10-04 12:59:28 0 [Note] InnoDB: Restricted to 2016 pages due to innodb_buf_pool_dump_pct=25
2022-10-04 12:59:28 0 [Note] InnoDB: Buffer pool(s) dump completed at 221004 12:59:28
2022-10-04 12:59:28 0 [Note] InnoDB: Removed temporary tablespace data file: "./ibtmp1"
2022-10-04 12:59:28 0 [Note] InnoDB: Restricted to 2016 pages due to innodb_buf_pool_dump_pct=25
2022-10-04 12:59:28 0 [Note] InnoDB: Buffer pool(s) dump completed at 221004 12:59:28
2022-10-04 12:59:28 0 [Note] InnoDB: Removed temporary tablespace data file: "./ibtmp1"
2022-10-04 12:59:28 0 [Note] InnoDB: Shutdown completed; log sequence number 35941727; transaction id 115336
2022-10-04 12:59:28 0 [Note] mariadbd: Shutdown complete

srun: error: eio_message_socket_accept: slurm_receive_msg[10.61.12.11:49092]: Zero Bytes were transmitted or received
srun: error: eio_message_socket_accept: slurm_receive_msg[10.61.12.11:49094]: Zero Bytes were transmitted or received
srun: error: eio_message_socket_accept: slurm_receive_msg[10.61.12.11:49096]: Zero Bytes were transmitted or received
srun: error: eio_message_socket_accept: slurm_receive_msg[10.61.12.11:49098]: Zero Bytes were transmitted or received
srun: error: eio_message_socket_accept: slurm_receive_msg[10.61.12.11:49100]: Zero Bytes were transmitted or received
srun: error: eio_message_socket_accept: slurm_receive_msg[10.61.12.11:49102]: Zero Bytes were transmitted or received
srun: error: Node failure on ant11
srun: error: Node failure on ant11
srun: Force Terminated job 595767
