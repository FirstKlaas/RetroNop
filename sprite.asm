.label SCREEN_RAM = $0400
.label RAM = $d800
.label SPRITE0PTR = SCREEN_RAM+$03f8 // Pointer auf den 64 byte Block des Sprite 0
.label SPRITE1PTR = SCREEN_RAM+$03f9 // Pointer auf den 64 byte Block des Sprite 1

BasicUpstart2(start)

#import "libs/vic.asm"
#import "libs/color.asm"
#import "libs/common.asm"

start:
    jsr $e544
    jsr common.deactivate_basic
    SetBorderColor(COLOR.BLACK)
    SetBackgroundColor(COLOR.BLACK)
    
    lda #<sprite01                     //LSB der Spritedaten holen
    sta calc16Bit                      //im 'Hilfsregister' speichern
    lda #>sprite01                     //MSB auch
    sta calc16Bit+1                    //ins 'Hilfregister'
    ldx #$06                           //Schleifenzähler fürs Teilen durch 64
loop:
    lsr calc16Bit+1                    //MSB nach rechts 'shiften'
    ror calc16Bit                      //LSB nach rechts 'rotieren', wg. Carry-Flag!
    dex                                //Schleifenzähler verringern
    bne loop                           //wenn nicht 0, nochmal
    
    ldx calc16Bit                      //Im LSB des 'Hilfsregisters' steht der 64-Byte-Block
    stx SPRITE0PTR                     //In der zuständigen Speicherstelle ablegen
    stx sprite01block
    
    //*** Weitere Sourcezeilen ab hier einfügen...
    lda #%00000000                      //Keine Vergrößerung gewünscht
    sta VIC.SPRITEDOUBLEHEIGHT          //doppelte Höhe zurücksetzen
    sta VIC.SPRITEDOUBLEWIDTH           //doppelte Breite zurücksetzen
    
    lda #%00000000                      //Nur High Res Sprites
    sta VIC.SPRITEMULTICOLOR                //Multicolor für Sprite-1 aktivieren

    lda #%00000000                      //Alle Sprites vor dem Hintergrund anzeigen
    sta VIC.SPRITEDEEP
        
    lda #%00000000                      //Alle Sprites vor dem Hintergrund anzeigen
    sta VIC.SPRITEDEEP

    lda #COLOR.PURPLE                   //Farbe für
    sta VIC.SPRITE0COLOR                //Sprite-0 (hat nur eine, da Hi-Res!)
 
    ldx #$00                            //Zur Sicherheit das höchste
    stx VIC.SPRITESMAXX                 //Bit für die X-Position löschen
    ldx #$20                            //X-Pos für
    stx VIC.SPRITE0X                    //Sprite-0
    
    ldy #$80                            //Y-Position
    sty VIC.SPRITE0Y                    //für Sprite-0

    lda #%00000001                      //nur Sprite-0
    sta VIC.SPRITEACTIV                 //aktivieren, alle anderen ausblenden


    
!:
    // Testcode
    lda #<animationdata.sp0
    sta REG00
    lda #>animationdata.sp0
    sta REG00+1
    jsr nextsprite
    WaitForRasterline(255)    
    jmp !-


/*****************************************************************************
* Sprite Animation Data
* ============================================================================
* Hier speichern wir die Animationsdaten zu den einzelnen sprites. 
*
* Byte 00: Anzahl der Frames für dieses Spriteanimation
* Byte 01: Aktueller Frame in der Animationssequenze
*****************************************************************************/
animationdata: {
    .byte
    sp0: //Daten fuer Sprite 0
        .byte $04, $04
}

nextsprite: {
    // REG00 (in Zeropage) zeigt auf animationdata.sp0
    
    // Lade den aktuellen Frame
    ldy #1
    lda (REG00),y // Aktuellen Frame in den Akku laden
    tay           // und in das y register verschieben

    dey                       // Decrease Framenr in sprite set
    bne next                  // If 0 start again
    // Lade die anzahl der Frames fuer dieses Spriteset
    // In REG00 und REG01 ist die Afdresse des aktuellen animadtiondata Blocks
    // abgelegt.
    ldy #0                  
    lda (REG00),y
    tay
    //ldy animationdata.sp0     // Initialize current frame with number of frames
    ldx sprite01block
    jmp !+
    
next:
    ldx SPRITE0PTR
    inx
!:
    sty animationdata.sp0 + 1  // Save current frame
    stx SPRITE0PTR             // Move sprite pointer to next sprite (block)

    // Nach rechts bewegen
    ldx $d000
    inx
    stx $d000
    rts

}

//*** Hilfsregister für 16-Bit Operationen
calc16Bit:
 .byte $00, $00

/**
* "Zero Page Register"
*/
.label REG00 = $00BF

// Here starts the sprite data, let's see, if the vic can read
// this.
* = $0940 "Sprite Data"
sprite01:
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $6C, $00
	.byte $00, $28, $00
	.byte $00, $28, $00
	.byte $00, $54, $00
	.byte $00, $54, $00
	.byte $00, $7C, $00
	.byte $00, $6C, $00
	.byte $00, $FE, $00
	.byte $01, $FF, $00
	.byte $01, $FF, $00
	.byte $03, $7D, $80
	.byte $06, $7C, $C0
	.byte $06, $FC, $C0
	.byte $00, $6C, $00
	.byte $00, $EE, $00
	.byte $00, $0E, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
sprite01block:
    .byte $00

sprite02:
	.byte $00, $00, $00
	.byte $00, $00, $00
	.byte $00, $44, $00
	.byte $00, $28, $00
	.byte $00, $28, $00
	.byte $00, $28, $00
	.byte $00, $7C, $00
	.byte $00, $54, $00
	.byte $00, $7C, $00
	.byte $00, $44, $00
	.byte $00, $FE, $00
	.byte $01, $FF, $00
	.byte $03, $FF, $80
	.byte $07, $7D, $C0
	.byte $06, $7C, $C0
	.byte $00, $7E, $00
	.byte $00, $6C, $00
	.byte $00, $EE, $00
	.byte $00, $E0, $00
	.byte $00, $00, $00
	.byte $00, $00, $00
    .byte $00
sprite03:
    .byte $00, $00, $00
    .byte $00, $00, $00
    .byte $00, $00, $00
    .byte $00, $6C, $00
    .byte $00, $28, $00
    .byte $00, $28, $00
    .byte $00, $54, $00
    .byte $00, $54, $00
    .byte $00, $7C, $00
    .byte $00, $6C, $00
    .byte $00, $FE, $00
    .byte $07, $FF, $C0
    .byte $07, $FF, $C0
    .byte $00, $7C, $00
    .byte $00, $7C, $00
    .byte $00, $FC, $00
    .byte $00, $6C, $00
    .byte $00, $EE, $00
    .byte $00, $0E, $00
    .byte $00, $00, $00
    .byte $00, $00, $00
    .byte $00

sprite04:
    .byte $00, $00, $00
    .byte $00, $00, $00
    .byte $00, $44, $00
    .byte $00, $28, $00
    .byte $00, $28, $00
    .byte $00, $28, $00
    .byte $00, $7C, $00
    .byte $00, $54, $00
    .byte $00, $7C, $00
    .byte $00, $44, $00
    .byte $00, $FE, $00
    .byte $01, $FF, $00
    .byte $03, $FF, $80
    .byte $07, $7D, $C0
    .byte $06, $7C, $C0
    .byte $00, $7E, $00
    .byte $00, $6C, $00
    .byte $00, $EE, $00
    .byte $00, $E0, $00
    .byte $00, $00, $00
    .byte $00, $00, $00
    .byte $00

sprite_space_invader:
    .byte $20,$80,$00,$11,$00,$00,$3f,$80
    .byte $00,$6e,$c0,$00,$ff,$e0,$00,$bf
    .byte $a0,$00,$a0,$a0,$00,$1b,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$0d