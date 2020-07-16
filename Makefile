compile:
	java -jar  ../KickAssembler/KickAss.jar sprite.asm -showmem

run: compile
	x64 -autostartprgmode 1 sprite.prg