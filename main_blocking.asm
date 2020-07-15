.label SCREEN_RAM = $0400
.label RAM = $d800

BasicUpstart2(start)

#import "libs/vic.asm"
#import "libs/color.asm"

#import "assets/encoway.asm"

ColorRamp:
    .byte $01, $03, $0e, $06, $0e, $03

ColorIndex:
    .byte $00

start:  

    lda #%00011000
    sta VIC.SPEICHER_KONTROLL_REG

    lda #COLOR.BLACK
    sta VIC.BORDER_COLOR
    sta VIC.BACKGROUND_COLOR

    jsr clearScreen
    jsr printEncoway

    jmp * // Endlosschleife

ScreenAnimation:
    ldx ColorIndex
    inx
    cpx #6
        bne !+
        ldx #0
!:
    stx ColorIndex
    
    jsr colorScreen
    
    // Hier wird getestet, ob aktuelle Rasterzeile ($D012)
    // den Wert $ff hat. Wenn nichtm wird weiter gewartet.
    // Dies ist also ein blockierendes Warten.
    lda #$ff
!:
    cmp $d012
    bne !-
    jmp ScreenAnimation


colorScreen: {
        ldy #0

    rampCycle: 

        // Update Color Index
        ldx ColorIndex
        inx
        cpx #6
        bne !+
        ldx #0
    !:
        stx ColorIndex
        lda ColorRamp, x
        sta RAM-1, y
        sta RAM + 39, y
        sta RAM+ 40*2 -1, y
        sta RAM+ 40*3 -1, y
        sta RAM+ 40*4 -1, y
        sta RAM+ 40*5 -1, y
        sta RAM+ 40*6 -1, y
        sta RAM+ 40*7 -1, y
        sta RAM+ 40*8 -1, y
        sta RAM+ 40*9 -1, y
        sta RAM+ 40*10 -1, y
        sta RAM+ 40*11 -1, y
        sta RAM+ 40*12 -1, y
        sta RAM+ 40*13 -1, y
        sta RAM+ 40*14 -1, y
        sta RAM+ 40*15 -1, y
        sta RAM+ 40*16 -1, y
        sta RAM+ 40*17 -1, y
        sta RAM+ 40*18 -1, y
        sta RAM+ 40*19 -1, y
        sta RAM+ 40*20 -1, y
        sta RAM+ 40*21 -1, y
        sta RAM+ 40*22 -1, y
        sta RAM+ 40*23 -1, y
        sta RAM+ 40*24 -1, y

        
        iny
        cpy #40
        bne rampCycle
        rts
}

printEncoway: {
        ldx #0
        // Print the base elements of the logo
    !:
        lda GRUNDELEMENT, x
        sta SCREEN_RAM + (8 * 40) + 16, x
        lda GRUNDELEMENT + 8, x
        sta SCREEN_RAM + (9 * 40) + 16, x
        lda GRUNDELEMENT + 16, x
        sta SCREEN_RAM + (10 * 40) + 16, x
        lda GRUNDELEMENT + 24, x
        sta SCREEN_RAM + (11 * 40) + 16, x
        lda GRUNDELEMENT + 32, x
        sta SCREEN_RAM + (12 * 40) + 16, x
        lda GRUNDELEMENT + 40, x
        sta SCREEN_RAM + (13 * 40) + 16, x
        lda GRUNDELEMENT + 48, x
        sta SCREEN_RAM + (14 * 40) + 16, x
        lda GRUNDELEMENT + 56, x
        sta SCREEN_RAM + (15 * 40) + 16, x
        
        inx
        cpx #8
        bne !-


        // Now print the text encoway 2020
        ldx #0
        ldy #$F0
    !:
        tya
        sta SCREEN_RAM + (18 * 40) + 16, x
        inx
        iny
        cpx #12 // 12 Zeichen
        bne !-        
        rts
}

// Dies ist meine erste IRQ Routine in assembler geschrieben.
rasterIRQ: {
    jsr colorScreen
    rts
}

clearScreen: {
        lda #86
        ldx #250
    !:
        dex
        sta SCREEN_RAM, x
        sta SCREEN_RAM + 250, x
        sta SCREEN_RAM + 500, x
        sta SCREEN_RAM + 750, x
        bne !-
        rts
}

* = $2000 "Charset"
#import "assets/font.asm"
