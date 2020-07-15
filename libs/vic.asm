.macro SetBackgroundColor(color) {    
    lda #color
    sta VIC.BACKGROUND_COLOR       
}

.macro SetBorderColor(color) {    
    lda #color
    sta VIC.BORDER_COLOR
}

.macro WaitForRasterline(line) {
        ldx #40
    !:
        lda VIC.RASTERLINE
        cmp #line
        bne !-
        dex
        bne !-
}

 //*******************************************************************************
 //*** Die VIC II Register  -  ANFANG                                          ***
 //*******************************************************************************
VIC: {
    .label VICBASE                  = $d000         // (RG) = Register-Nr.
    .label SPRITE0X                 = $d000         // (00) X-Position von Sprite 0
    .label SPRITE0Y                 = $d001         // (01) Y-Position von Sprite 0
    .label SPRITE1X                 = $d002         // (02) X-Position von Sprite 1
    .label SPRITE1Y                 = $d003         // (03) Y-Position von Sprite 1
    .label SPRITE2X                 = $d004         // (04) X-Position von Sprite 2
    .label SPRITE2Y                 = $d005         // (05) Y-Position von Sprite 2
    .label SPRITE3X                 = $d006         // (06) X-Position von Sprite 3
    .label SPRITE3Y                 = $d007         // (07) Y-Position von Sprite 3
    .label SPRITE4X                 = $d008         // (08) X-Position von Sprite 4
    .label SPRITE4Y                 = $d009         // (09) Y-Position von Sprite 4
    .label SPRITE5X                 = $d00a         // (10) X-Position von Sprite 5
    .label SPRITE5Y                 = $d00b         // (11) Y-Position von Sprite 5
    .label SPRITE6X                 = $d00c         // (12) X-Position von Sprite 6
    .label SPRITE6Y                 = $d00d         // (13) Y-Position von Sprite 6
    .label SPRITE7X                 = $d00e         // (14) X-Position von Sprite 7
    .label SPRITE7Y                 = $d00f         // (15) Y-Position von Sprite 7
    .label SPRITESMAXX              = $d010         // (16) Höhstes BIT der jeweiligen X-Position
                                                    //      da der BS 320 Punkte breit ist reicht
                                                    //      ein  .byte für die X-Position nicht aus!
                                                    //      Daher wird hier das 9. Bit der X-Pos
                                                    //      gespeichert. BIT-Nr. (0-7) = Sprite-Nr.
    .label RASTERLINE               = $d012         // Aktuelle rasterzeile (unteren 8 bit)
    .label SPRITEACTIV              = $d015         // (21) Bestimmt welche Sprites sichtbar sind
                                                    //      Bit-Nr. = Sprite-Nr.
    .label SPRITEDOUBLEHEIGHT       = $d017         // (23) Doppelte Höhe der Sprites
                                                    //      Bit-Nr. = Sprite-Nr.
    .label SPEICHER_KONTROLL_REG    = $d018
    .label SPRITEDEEP               = $d01b         // (27) Legt fest ob ein Sprite vor oder hinter
                                                    //      dem Hintergrund erscheinen soll.
                                                    //      Bit = 1: Hintergrund vor dem Sprite
                                                    //      Bit-Nr. = Sprite-Nr.
    .label SPRITEMULTICOLOR         = $d01c         // (28) Bit = 1: Multicolor Sprite 
                                                    //      Bit-Nr. = Sprite-Nr.
    .label SPRITEDOUBLEWIDTH        = $d01d         // (29) Bit = 1: Doppelte Breite des Sprites
                                                    //      Bit-Nr. = Sprite-Nr.
    .label SPRITESPRITECOLL         = $d01e         // (30) Bit = 1: Kollision zweier Sprites
                                                    //      Bit-Nr. = Sprite-Nr.
                                                    //      Der Inhalt wird beim Lesen gelöscht!!
    .label SPRITEBACKGROUNDCOLL     = $d01f         // (31) Bit = 1: Sprite / Hintergrund Kollision
                                                    //      Bit-Nr. = Sprite-Nr.
                                                    //      Der Inhalt wird beim Lesen gelöscht!
    .label BORDER_COLOR             = $d020
    .label BACKGROUND_COLOR         = $d021
    .label SPRITEMULTICOLOR0        = $d025         // (37) Spritefarbe 0 im Multicolormodus
    .label SPRITEMULTICOLOR1        = $d026         // (38) Spritefarbe 1 im Multicolormodus
    .label SPRITE0COLOR             = $d027         // (39) Farbe von Sprite 0
    .label SPRITE1COLOR             = $d028         // (40) Farbe von Sprite 1
    .label SPRITE2COLOR             = $d029         // (41) Farbe von Sprite 2
    .label SPRITE3COLOR             = $d02a         // (42) Farbe von Sprite 3
    .label SPRITE4COLOR             = $d02b         // (43) Farbe von Sprite 4
    .label SPRITE5COLOR             = $d02c         // (44) Farbe von Sprite 5
    .label SPRITE6COLOR             = $d02d         // (45) Farbe von Sprite 6
    .label SPRITE7COLOR             = $d02e         // (46) Farbe von Sprite 7
}
