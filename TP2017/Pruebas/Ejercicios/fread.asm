;******************************************************************************************************
; fread.asm
;
; Abre un archivo, lee registros, los imprime y lo cierra
;******************************************************************************************************
segment pila stack
resb 64
segment datos data

fileName	db	"archi.txt",0	;el nombre del archivo debe terminar con un 0 binario!!!!
fHandle		resw	1
registro	times 15 resb 1

msjErrOpen	db	"Error en apertura$"
msjErrRead	db	"Error en lectura$"
msjErrClose	db	"Error en cierre$"

segment codigo code
..start:
	mov  ax,datos  ;ds <-- dir del segmento de datos
	mov  ds,ax
         
	;ABRE EL ARCHIVO PARA LECTURA
	mov	al,0		         ;al = tipo de acceso (0=lectura; 1=escritura; 2=lectura y escritura)
	mov	dx,fileName	         ;dx = dir del nombre del archivo
	mov	ah,3dh		         ;ah = servicio para abrir archivo 3dh
	int	21h
	jc	errOpen
	mov	[fHandle],ax	         ; en ax queda el handle del archivo

	;LEE EL ARCHIVO (registro 1)
	mov	bx,[fHandle]	;bx = handle del archivo
	mov	cx,10		;cx = cantidad de bytes a escribir
	mov	dx,registro	;dx = dir del area de memoria q contiene los bytes leidos del archivo
	mov	ah,3fh		;ah = servicio para escribir un archivo: 40h
	int	21h
	jc	errRead
         cmp      ax,0
         je       closeFil
	;IMPRIME POR PANTALLA (registro 1)
	mov	byte[registro+10],10
	mov	byte[registro+11],13
	mov	byte[registro+12],'$'
	mov	dx,registro
	mov	ah,9
	int	21h

	;LEE EL ARCHIVO (registro 2)
	mov	bx,[fHandle]	;bx = handle del archivo
	mov	cx,10		;cx = cantidad de bytes a escribir
	mov	dx,registro	;dx = dir del area de memoria q contiene los bytes leidos del archivo
	mov	ah,3fh		;ah = servicio para escribir un archivo: 40h
	int	21h
	jc	errRead
         cmp      ax,0
         je       closeFil
	;IMPRIME POR PANTALLA (registro 2)
	mov	byte[registro+10],10
	mov	byte[registro+11],13
	mov	byte[registro+12],'$'
	mov	dx,registro
	mov	ah,9
	int	21h
         jmp      closeFil
errOpen:
	mov	dx,msjErrOpen
	mov	ah,9
	int	21h
	jmp	fin
errRead:
	mov	dx,msjErrRead
	mov	ah,9
	int	21h
closeFil:
	;CIERRA EL ARCHIVO
	mov	bx,[fHandle]	;bx = handle del archivo
	mov	ah,3eh		;ah = servicio para cerrar archivo: 3eh
	int	21h
	jc	errClose
	jmp	fin
errClose:
	mov	dx,msjErrClose
	mov	ah,9
	int	21h
fin:
	mov  ax,4c00h  ; retornar al DOS
	int  21h