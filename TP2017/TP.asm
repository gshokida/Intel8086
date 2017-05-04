segment datos data
		msjInicial		db 'Comenzando el proceso de conversiones...$'
		msjFinal		db 'Fin del proceso de conversiones$'
		msjErrOpen		db 'Error en apertura$'
		msjErrRead		db 'Error en lectura$'
		msjErrClose		db 'Error en cierre$'
		
		archivo   		db 'fechas.dat' ;el nombre del archivo debe terminar con un 0 binario
		                db 0
						
		fHandle			resw	1
		salto 			db 13,10,'$'
		
		registro 		times 6 resb
		
segment pila stack
		resb 64
stacktop:
		
segment codigo code
..start:
		mov ax,datos
		mov ds,ax
		mov ax,pila
		mov ss,ax
		mov sp,stacktop
		
inicio:
		call imprimirMensajeInicio
		
abrirArchivo:
		mov dx,filename			;dx = dir del nombre del archivo
		mov ah,3dh				;ah = servicio para abrir archivo 3dh
		mov al,0				;al = tipo de acceso (0=lectura; 1=escritura; 2=lectura y escritura)
		int 21h
		jc	errOpen
		mov	[fHandle],ax		; en ax queda el handle del archivo
		
obtenerRegistro:
		mov bx,[fHandle]		;bx = handle del archivo
		mov cx,6				;cx = cantidad de bytes a escribir
		mov ah,3fh				;ah = servicio para leer desde un archivo: 3fh
		mov dx,registro			;dx = dir del area de memoria q contiene los bytes leidos del archivo
		int 21h
		jc	errRead
		cmp      ax,0			;ax = cantidad de bytes leidos
        je       cierroArchivo	;si la cantidad de bytes leidos es 0 termine de leer el archivo
		
		;TODO: realizar codificacion
		
		
cierroArchivo:
		mov bx,[fHandle]		;bx = handle del archivo
		mov ah,3eh				;ah = servicio para cerrar archivo: 3eh
		int 21h
		jc	errClose
		call imprimirMensajeFinal
		mov ah,1
		int 21h
		
finPrograma:
		mov ah,4Ch
		int 21h

		
;**********************************************************************
; Imprimo errores con manejo de archivos
;**********************************************************************
errOpen:
	lea dx,[msjErrOpen]
	call imprimirMensaje
	jmp	finPrograma
	
errRead:
	lea dx,[msjErrRead]
	call imprimirMensaje
	jmp cierroArchivo
	
errClose:
	lea dx,[msjErrClose]
	call imprimirMensaje
	jmp finPrograma
	
;**********************************************************************
; Imprimo un enter en la pantalla
;**********************************************************************
imprimirEnter:
		mov dx,salto
		mov ah,9h
		int 21h
		ret
		
;**********************************************************************
; Imprimo mensaje
;**********************************************************************
imprimirMensaje:
		mov ah,9
		int 21h
		call imprimirEnter
		ret
		
;**********************************************************************
; Imprimo mensaje de inicio
;**********************************************************************
imprimirMensajeInicio:
		lea dx,[msjInicial]
		call imprimirMensaje
		ret
		
;**********************************************************************
; Imprimo mensaje de inicio
;**********************************************************************
imprimirMensajeFinal:
		lea dx,[msjFinal]
		call imprimirMensaje
		ret