segment datos data
		menuInicio		db '---------------      MENU     ---------------$'
		menuIngresar	db '1) Ingresar un elemento a un conjunto$'
		menuPertenencia	db '2) Elemento pertenece a un conjunto$'
		menuIgualdad	db '3) Verificar igualdad entre dos conjuntos$'
		menuInclusion	db '4) Verificar inclusion de un conjunto en otro$'
		menuSalir		db '5) Salir$'
		menuFin			db '---------------------------------------------$'
		menuSeleccionar	db 'Seleccionar opcion [1-5]$'

		menuOpcion resb 1
		           db  '$'

		mensajeFin db '=========>    FIN    <=========$'
		
		salto db 13,10,'$'
		
segment pila stack
		resb 64
stacktop:

segment codigo code
..start:
	;incialización de registro DS, SS y el puntero a la PILA
		mov ax,datos
		mov ds,ax
		mov ax,pila
		mov ss,ax
		mov sp,stacktop

inicio:
		call  imprimirMenu 

salir:		
		mov ah,4ch
		int 21h

;**********************************************************************
;*RUTINAS
;**********************************************************************
;**********************************************************************
;Imprimir Menu
;**********************************************************************
imprimirMenu:
		lea dx,[menuInicio]
		call imprimirMensaje
		call ejecutarEnter
		call ejecutarEnter
	
		lea dx,[menuIngresar]
		call imprimirMensaje
		call ejecutarEnter
		
		lea dx,[menuPertenencia]
		call imprimirMensaje
		call ejecutarEnter
		
		lea dx,[menuIgualdad]
		call imprimirMensaje
		call ejecutarEnter

		lea dx,[menuInclusion]
		call imprimirMensaje
		call ejecutarEnter
		
		lea dx,[menuSalir]
		call imprimirMensaje
		call ejecutarEnter

		lea dx,[menuFin]
		call imprimirMensaje
		call ejecutarEnter

		lea dx,[menuSeleccionar]
		call imprimirMensaje
		call ejecutarEnter

		ret

;**********************************************************************
;Imprimir Mensajes
;**********************************************************************
imprimirMensaje:
		mov ah,9
		int 21h
		ret

;**********************************************************************
;Agregar un Enter
;**********************************************************************
ejecutarEnter:
		mov dx,salto
		mov ah,9h
		int 21h
		ret