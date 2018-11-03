segment datos data
		; Mensajes
		msjInicial		db 'Iniciando aplicación...','$'
		msjFinal		db 'Fin del programa','$'
		menuOpciones    db  'Seleccionar opcion [1-3]','$'
		msjIngresoHex   db '1) Ingresar numero Hexadecimal','$'
		msjIngresoOct   db '2) Ingresar numero Octal','$'
		msjIngresoOut   db '3) Salir','$'
		msjConvertOct   db 'Convertir a Octal: ','$'
		msjConvertHex   db 'Convertir a Hexadecimal','$'
		msjErrOpen		db 'Error en apertura','$'
		
		menuInput  resb 1
		           db  '$'
		
		; Para el enter
		salto 			db 13,10,'$'
		
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

		call imprimirMenu
		
		call chooseOperation
		

		call imprimirMensajeFinal
		mov ah,1
		int 21h
		
finPrograma:
		mov ah,4Ch
		int 21h

chooseOperation:
		; pido ingresar opcion [1-2]
		mov ah,1
		int 21h
		;obtengo la opcion ingresada		
		mov byte[menuInput],al
		
		cmp  byte[menuInput],'1'
		je   finPrograma
		
		cmp  byte[menuInput],'2'
		je   finPrograma
		
		cmp  byte[menuInput],'3'
		je  finPrograma
		
		jne inicio
;**********************************************************************
; Imprimo mensaje de inicio
;**********************************************************************
imprimirMenu:
		lea dx,[msjIngresoHex]
		call imprimirMensaje
		lea dx,[msjIngresoOct]
		call imprimirMensaje
		lea dx,[msjIngresoOut]
		call imprimirMensaje
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