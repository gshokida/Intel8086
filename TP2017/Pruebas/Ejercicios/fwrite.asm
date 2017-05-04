;******************************************************************************************************
; fwrite.asm
; 
; Abre un archivo, escribe 3 registros y lo cierra
; El archivo DEBE existir, sino da error en el intento de apertura
; Al abrirlo lo borra
;******************************************************************************************************

segment pila stack
resb 64
segment datos data

fileName	db	"archi.txt",0	;el nombre del archivo debe terminar con un 0 binario!!!!
fHandle		resw 1
registro1	db	"1234567890"
registro2	db	"abcdefghij"
registro3	db	"ABCDEFGHIJ"

msjOk             db       "Escribio y cerro ok$"
msjErrOpen	db	"Error en apertura$"
msjErrClose	db	"Error en cierre$"
msjErrWrite	db	"Error en escritura$"

segment codigo code
..start:
	mov  ax,datos  ;ds <-- dir del segmento de datos
	mov  ds,ax
         

	;ABRE EL ARCHIVO PARA ESCRITURA
	mov	al,1		         ;al = tipo de acceso (0=lectura; 1=escritura; 2=lectura y escritura)
	mov	dx,fileName	         ;dx = dir del nombre del archivo
	mov	ah,3dh		         ;ah = servicio para abrir archivo 3dh
	int	21h
	jc	errOpen
	mov	[fHandle],ax	         ; en ax queda el handle del archivo

	;ESCRIBE EL ARCHIVO
	mov	bx,[fHandle]	         ;bx = handle del archivo
	mov	cx,10		         ;cx = cantidad de bytes a escribir
	mov	dx,registro1	         ;dx = dir del area de memoria q contiene los bytes a escribir
	mov	ah,40h		         ;ah = servicio para escribir un archivo: 40h
	int	21h
	jc	errWrite
	;ESCRIBE EL ARCHIVO
	mov	bx,[fHandle]
	mov	cx,10
	mov	dx,registro2
	mov	ah,40h
	int	21h
	jc	errWrite
	;ESCRIBE EL ARCHIVO
	mov	bx,[fHandle]
	mov	cx,10
	mov	dx,registro3
	mov	ah,40h
	int	21h
	jc	errWrite

	;CIERRA EL ARCHIVO
	mov	bx,[fHandle]	;bx = handle del archivo
	mov	ah,3eh		;ah = servicio para cerrar archivo: 3eh
	int	21h
	jc	errClose
	;IMPRIMO MENSAJE DE FIN OK
         mov	dx,msjOk
	mov	ah,9
	int	21h
	jmp	fin

errOpen:
	mov	dx,msjErrOpen
	mov	ah,9
	int	21h
	jmp	fin
errWrite:
	mov	dx,msjErrWrite
	mov	ah,9
	int	21h
	jmp	fin
errClose:
	mov	dx,msjErrClose
	mov	ah,9
	int	21h
fin:
	mov  ax,4c00h  ; retornar al DOS
	int  21h