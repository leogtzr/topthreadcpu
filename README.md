# Usage:

```
./lwp_check.sh [--stlen <STACKTRACE_LENGTH> --count <LWP_COUNT] | [--help|-h]
```

## Output

```
./lwp_check.sh --count 7 --stlen 14 | less -Ri
```

```
Analyzing ===> {ATGWebServices01}, pid: 26721
Top 7 lwps for ATGWebServices01 - 26721
 2.7 26721 26787  511 up000058  2.7 Feb23  2-18:03:09   511
 0.5 26721 26757  511 up000058  0.5 Feb23  2-18:03:11   511
 0.2 26721 26739  511 up000058  0.2 Feb23  2-18:03:11   511
 0.1 26721 26784  511 up000058  0.1 Feb23  2-18:03:09   511
 0.0 26721 28094  511 up000058  0.0 Feb23  2-17:54:32   511
 0.0 26721 28086  511 up000058  0.0 Feb23  2-17:54:39   511
 0.0 26721 27946  511 up000058  0.0 Feb23  2-17:56:04   511
lwp: 26787 -> 0x68a3
"dtmetricstimer" #22 daemon prio=5 os_prio=0 tid=0x00007fc0f4001000 nid=0x68a3 runnable [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

   Locked ownable synchronizers:
        - None

"dtcontroller" #21 daemon prio=5 os_prio=0 tid=0x00007fc110001000 nid=0x689e runnable [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

   Locked ownable synchronizers:
        - None

"dtautosensor" #20 daemon prio=5 os_prio=0 tid=0x00007fc10c001000 nid=0x689d runnable [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

lwp: 26757 -> 0x6885
"VM Thread" os_prio=0 tid=0x00007fc20c861000 nid=0x6885 runnable

"Gang worker#0 (Parallel GC Threads)" os_prio=0 tid=0x00007fc20c36e800 nid=0x6866 runnable

"Gang worker#1 (Parallel GC Threads)" os_prio=0 tid=0x00007fc20c365800 nid=0x6867 runnable

...

```

![usage](topthreadcpu/images/lwp_check-usage.png)