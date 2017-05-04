segment datos data
		salto 			db 13,10,'$'
		msjInicial		db 'Comenzando el proceso de conversiones...$'
		msjFinal		db 'Fin del proceso de conversiones$'

		archivo   		db 'fechas.dat$'
		
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
		call imprimirEnter
		
		;abrir el archivo
		mov dx,filename
		mov ah,3Dh
		mov al,0
		int 21h
		
		;codificar la lectura del archivo
		
cierroArchivo:
		mov bx,ax
		mov ah,3Eh
		int 21h
		
		call imprimirMensajeFinal
		call imprimirEnter
		
		mov ah,1
		int 21h
		
finPrograma:
		mov ah,4ch
		int 21h
		
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