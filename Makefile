compile:
	java -jar  ../KickAssembler/KickAss.jar main.asm -showmem

run: compile
	x64 -autostartprgmode 1 sprite.prg