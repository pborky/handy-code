all: clean suspend hibernate

clean:
	rm -fr sleep hibernate
suspend:
	gcc -std=c99 suspend.c -o suspend

hibernate:
	gcc -std=c99 hibernate.c -o hibernate

setuid:
	chown root suspend hibernate
	chmod u+s suspend hibernate
