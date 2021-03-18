; A small program to copy a prg file to its proper location and run it

*= $8000
; C128 feature rom header
!zone romcode {
cartheader
        jmp rominit
        jmp rominit

        !byte $02           ; Do not start early. Change to 01 to start before kernal init (and fix rominit to handle this!)
        !convtab pet
        !tx "cbm"
        !byte 0,0

!tx "length:"
plsrc                       ; program length source, we copy this to plength for the copy operation.
!word (prgend - prgstart)



!src "cbm/zeropage128.asm"
!src "cbm/kernal128.asm"

enter_basic=$0140

writeptr = kworkptr2        ; load/save end ptr
readptr = $fb               ; source data
plength = $fd               ; number of bytes to copy

rominit
        sei
        lda $ff00
        and #%00001110      ; enable io, kernal rom and ensure ram bank 0
        ora #%00000010      ; enable low ram ($4000-$7fff)
        sta $ff00
        and #%00001100      ; get the bits identifying which slot we run from so we can enable high rom
        asl                 ; move them to the position for the high rom selection bits
        asl
        ora $ff00           ; combine with current config
        ora #%00000001      ; disable i/o for copying (we may want to read data from $d000-dfff)
        pha                 ; store for later use
        ldx #0
-
        lda .initmsg,x      ; print startup message
        beq +
        jsr CHROUT
        inx
        bne -
+
        ; copy stackcode
        ldx #.lowcode_end - .lowcode_start
-
        lda .lowcode_start,x 
        sta enter_basic,x
        dex
        bpl -

        lda plsrc           ; setup length counter
        sta plength
        lda plsrc+1
        sta plength+1
        lda #<prgstart+2    ; setup source address
        sta readptr
        lda #>prgstart+2
        sta readptr+1

        lda prgstart        ; setup destination address and basic start address
        sta basicstart
        sta writeptr
        lda prgstart+1
        sta basicstart+1
        sta writeptr+1

        ldy #1
        sty $d030           ; 2mhz mode, need to do this before disabling i/o...
        dey
        pla                 ; retrieve memory config we stashed previously
        sta $ff00           ; and enable the high rom part of the function rom
.copyloop
        lda (readptr),y
        sta (writeptr),y
        inc readptr
        bne +
        inc readptr+1
+       inc writeptr
        bne +
        inc writeptr+1
+       dec plength
        lda plength
        cmp #$ff
        bne .copyloop
        dec plength+1
        lda plength+1
        cmp #$ff
        bne .copyloop

.exit
        lda writeptr
        sta $1210
        lda writeptr+1
        sta $1211
        lda $ff00
        and #%00001110      ; enable kernal rom and i/o
        sta $ff00
        sec                 ; save current cursor position
        jsr PLOT
        txa
        pha
        tya
        pha

        ldx #0              ; print "run"
-
        lda .runstatement,x
        beq +
        jsr CHROUT
        inx
        bne -
+
        pla                 ; restore cursor position
        tay
        pla
        tax
        clc
        jsr PLOT
        lda #$0d            ; put a return in the keyboard buffer
        sta $034a
        lda #1              ; indicate there is one key in the buffer
        sta ndx
        cli
        lda #0              ; preload a with desired memory config (all system roms enabled, aka bank 15 so we can enter basic)
        sta $d030           ; and while at it.. disable 2mhz mode
        jmp enter_basic     ; call the stackcode we put in place earlier.


!if 0 {
.initmsg
!tx "rgbi scart adapter test"
!byte $0d
!tx "(c) 2021 sven pook"
!byte $0d
!tx "cartified by bart van leeuwen"
!byte $0d,0
}

.initmsg
!tx "fromify 1.0"
!byte $0d
!tx "copyright 2021 bart van leeuwen"
!byte $0d,0

.runstatement
!byte $0d,$0d
!tx "run"
!byte $0d,0

; this gets copied to the stack before being called, it will disable our rom and call basic warm start
.lowcode_start
        sta $ff00
        jmp $4003
.lowcode_end
}


prgstart
!bin "software.prg"
!byte 0,0,0
prgend


; check if this will be a 16k or 32k rom.. or possibly too large?
!if * > $c000 {
        ; ensure we do not write past $feff, as we get hidden by mmu registers and need specific content in remainder of page $ff.
        !if * > $ff00 {
                !error "prg file too large"
        } else {
                ; include kernal top code for irq handler etc.
                !src "cbm/kernal128top.asm"
        }
} else {
       *=$c000
}
