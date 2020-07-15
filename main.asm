.label SCREEN_RAM = $0400
.label RAM = $d800

BasicUpstart2(start)

#import "libs/vic.asm"
#import "libs/color.asm"

#import "assets/encoway.asm"
#import "assets/screen0.asm"

.label COUNT_COLORS = 6

ColorRamp:
    .byte $01, $03, $0e, $06, $0e, $03

ColorIndex:
    .byte $00

FrameTrigger:
    .byte $ff

start:  

    lda #%00011000
    sta VIC.SPEICHER_KONTROLL_REG

    lda #COLOR.BLACK
    sta VIC.BACKGROUND_COLOR
    sta VIC.BORDER_COLOR
    
    //jsr clearScreen
    jsr printScreen

    // Erste Zeile weiss faerben
    ldy #16
    lda #1
!:    
    sta RAM + 164, y
    dey
    bne !-

    // Unterzeile weiss faerben
    ldy #20
    lda #1
!:    
    sta RAM + 16*40 + 14, y
    dey
    bne !-

    // Fire faerben
    ldy #80
    lda #10
!:    
    sta RAM + 21*40, y
    dey
    bne !-

    // IRQ einrchten
    sei 
    lda #<colorScreen                  //unsere Interrupt-Routine
    sta $0314                          //in den IRQ-Vector eingtragen
    lda #>colorScreen                  //auch das MSB
    sta $0315
    
    lda #$ff                           //Bei $00ff soll ein
    sta $d012                          //Raster-IRQ ausgelöst werden
    
    lda $d011                          //Zur Sicherheit auch noch
    and #%01111111                     //das höhste Bit für den
    sta $d011                          //gewünschten Raster-IRQ löschen 
    
    lda $d01a                          //IRQs vom
    ora #%00000001                     //VIC-II aktivieren
    sta $d01a
    cli       
    jmp * // Endlosschleife

colorScreen: {

        // Testen, ob der IRG durch den Raster ausgelöst wurde.
        lda $d019
        and #%00000001  // Raster IRQ? Bit #7 ist dann 1
        bne determineNextColor // Jawoll
        lda $dc0d       // sonst, CIA-IRQ bestätigen  
        cli             // IRQs erlauben
        jmp $ea31

    

    determineNextColor: // Naechste zu verwendende Farbe ermitteln.
        //sty FrameTrigger
        //lda $d019                         
        sta $d019 
        ldy #0
    
    rampCycle: 
    
        ldx ColorIndex
        inx
        cpx #6
        bne !+
        ldx #0
    !:
        stx ColorIndex
        
        lda ColorRamp, x
        sta RAM + (6*40) + 5, y
        sta RAM + (7*40) + 5, y
        sta RAM + (8*40) + 5, y
        sta RAM + (9*40) + 5, y
        sta RAM + (10*40) + 5, y
        sta RAM + (11*40) + 5, y
        sta RAM + (12*40) + 5, y
        sta RAM + (13*40) + 5, y
        sta RAM + (14*40) + 5, y
        sta RAM + (15*40) + 5, y
        iny
        cpy #31
        bne rampCycle

    rasterIrqExit:

        //ldx VIC.BORDER_COLOR
        //inx
        //stx VIC.BORDER_COLOR

        pla                                //Y vom Stack
        tay
        pla                                //X vom Stack
        tax
        pla                                //Akku vom Stack
        rti   
}

printScreen: {
        ldx #250

    !:
        lda screen0, x
        sta SCREEN_RAM, x
        lda screen0 + 250, x
        sta SCREEN_RAM + 250, x
        lda screen0 + 500, x
        sta SCREEN_RAM + 500, x
        lda screen0 + 750, x
        sta SCREEN_RAM + 750, x
        dex
        bne !-
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
