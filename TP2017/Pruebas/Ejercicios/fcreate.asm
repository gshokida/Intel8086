;******************************************************************************************************
; fcreate.asm
;
; Crea un archivo, escribe un registro y lo cierra
;******************************************************************************************************
segment pila stack
resb 64

segment datos data
fileName	db	"archi.txt",0	;el nombre del archivo debe terminar con un 0 binario!!!!
fHandle		resw 1
registro1	db	"**********"

msjErrCreate	db	"Error en creacion$"
msjErrWrite	db	"Error en escritura$"
msjErrClose	db	"Error en cierre$"
msjOk             db       "Creacion y escritura ok$"

segment codigo code
..start:
	mov  ax,datos  ;ds <-- dir del segmento de datos
	mov  ds,ax
         
	;CREA EL ARCHIVO (Si existe lo pisa!!! Lo deja abierto para escritura!!)
	mov	dx,fileName	         ;dx = dir del nombre del archivo (que finaliza con un 0 binario!!)
	mov	cx,0		         ;cx = Atributos
	mov	ah,3ch		         ;ah = servicio para crear archivo: 3ch
	int	21h		         ;crea el archivo (int 21h, serv 3ch)
	jc	errCreate	         ;Carry <> 0
	mov	[fHandle],ax	         ;en ax queda el handle del archivo

	;ESCRIBE EL ARCHIVO
	mov	bx,[fHandle]	         ;bx = handle del archivo
	mov	cx,10		         ;cx = cantidad de bytes a escribir
	mov	dx,registro1	         ;dx = dir del area de memoria q contiene los bytes a escribir
	mov	ah,40h		         ;ah = servicio para escribir un archivo: 40h
	int	21h
	jc	errWrite
         
	;CIERRA EL ARCHIVO
	mov	bx,[fHandle]	;bx = handle del archivo
	mov	ah,3eh		;ah = servicio para cerrar archivo: 3eh
	int	21h
	jc	errClose		;Carry <> 0

	;IMPRIMO MENSAJE DE FIN OK
         mov	dx,msjOk
	mov	ah,9
	int	21h
	jmp	fin
         
errCreate:
	mov	dx,msjErrCreate
	mov	ah,9
	int	21h
	jmp	fin
errWrite:
	mov	dx,msjErrWrite
	mov	ah,9
	int	21h
errClose:
	mov	dx,msjErrClose
	mov	ah,9
	int	21h
	jmp	fin
fin:
	mov  ax,4c00h  ; retornar al DOS
	int  21h