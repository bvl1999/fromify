SRCFILES = cart.asm cbm/zeropage128.asm cbm/kernal128.asm software.prg
ACMEFLAGS = -f plain --initmem 0 --maxdepth 16 -v2 --cpu 6502

all: cart

zip: archive

archive: target/cart.zip

srcarchive:
	tar cvzf target/cartsrc.tar.gz --exclude target/*.bin --exclude target/*.zip --exclude target/*.tar.gz ./*

target/cart.zip: target/cart.bin $(SRCFILES)
	mkdir -p target; cd target; rm -f cart.zip 2>/dev/null; zip cart.zip cart*.bin

cart: target/cart.bin

target/cart.bin: $(SRCFILES)
	acme $(ACMEFLAGS) -o target/cart.bin cart.asm

clean:
	rm -f target/*.bin target/*.zip

