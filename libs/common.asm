
.macro DeactivateBasic() {
    lda #54
    sta $0001
}    

.macro ClearScreen() {
    jsr $e544 // Clear Screen
}