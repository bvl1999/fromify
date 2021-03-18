; usefull internal functions

K_CHKOPEN = $f202 
K_ERROR1 = $f67c
K_ERROR2 = $f67f
K_ERROR3 = $f682
K_ERROR4 = $f685
K_ERROR5 = $f688
K_ERROR6 = $f68b
K_ERROR7 = $f68e
K_ERROR8 = $f691
K_ERROR9 = $f694
K_ERROR16 = $f697


; official C128 kernal jumptable 

SETBNK    = $ff68
GETCFG    = $ff6b
INDFET    = $ff74
INDSTA    = $ff77
INDCMP    = $ff7a
CINT      = $ff81
IOINIT    = $ff84
RAMTAS    = $ff87
RESTOR    = $ff8a
VECTOR    = $ff8d
SETMSG    = $ff90
SECOND    = $ff93
TKSA      = $ff96
MEMBOT    = $ff99
MEMTOP    = $ff9c
SCNKEY    = $ff9f
SETTMO    = $ffa2
ACPTR     = $ffa5
CIOUT     = $ffa8
UNTLK     = $ffab
UNLSN     = $ffae
LISTEN    = $ffb1
TALK      = $ffb4
READST    = $ffb7
SETLFS    = $ffba
SETNAM    = $ffbd
OPEN      = $ffc0
CLOSE     = $ffc3
CHKIN     = $ffc6
CHKOUT    = $ffc9
CLRCHN    = $ffcc
CHRIN     = $ffcf
CHROUT    = $ffd2
LOAD      = $ffd5
SAVE      = $ffd8
SETTIM    = $ffdb
RDTIM     = $ffde
STOP      = $ffe1
GETIN     = $ffe4
CLALL     = $ffe7
UDTIM     = $ffea
PLOT      = $fff0
