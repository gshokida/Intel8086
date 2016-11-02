segment datos data
		menuInicio		db '---------------      MENU     ---------------$'
		menuIngresar	db '1) Ingresar un elemento a un conjunto$'
		menuPertenencia	db '2) Elemento pertenece a un conjunto$'
		menuIgualdad	db '3) Verificar igualdad entre dos conjuntos$'
		menuInclusion	db '4) Verificar inclusion de un conjunto en otro$'
		menuSalir		db '5) Salir$'
		menuFin			db '---------------------------------------------$'
		menuSeleccionar	db 'Seleccionar opcion [1-5]$'
		
		menuOpcionInvalida db 'Debe seleccionar opcion [1-5]$'

		menuOpcion resb 1
		           db  '$'
		
		ingresarConjunto db 'Ingrese el conjunto al que se le quiere agregar el elemento [1-6]'
		ingresarElemento db 'Ingrese el elemento de 2 caracteres [A-Z,0-9]'

		ingresarConjunto resb 1
		ingresarElemento resb 2

		ingresarConjuntoNoValido db 'Debe ingresar un valor entre 1 y 6'
		ingresarElementoNoValido db 'Debe ingresar 2 caracteres [A-Z,0-9]



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

		;opcion [1-5]
		mov ah,1
		int 21h

		;obtengo la opcion ingresada		
		mov byte[menuOpcion],al

		cmp  byte[menuOpcion],'1'
		je   ingresarElemento
		
		cmp  byte[menuOpcion],'2'
		je   inicio
		
		cmp  byte[menuOpcion],'3'
		je  inicio

		cmp  byte[menuOpcion],'5'
		je   inicio
		
		cmp  byte[menuOpcion],'5'
		je  salir

		call imprimirMenuOpcionInvalida
		jmp inicio

salir:		
		mov ah,4ch
		int 21h




;**********************************************************************
;*RUTINAS
;**********************************************************************

;----------------------------------------------------------------------
;  Menu general
;----------------------------------------------------------------------
;**********************************************************************
;Imprimir Menu
;**********************************************************************
imprimirMenu:
		lea dx,[menuInicio]
		call imprimirMensaje
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
;Imprimir opción no valida del menu
;**********************************************************************
imprimirMenuOpcionInvalida:
		lea dx,[menuSeleccionar]
		call imprimirMensaje
		call ejecutarEnter
		ret

;----------------------------------------------------------------------
;  FIN Menu general
;----------------------------------------------------------------------

;----------------------------------------------------------------------
;  Ingresar valores a los conjuntos
;----------------------------------------------------------------------

;**********************************************************************
;Imprimir opción no valida del menu
;**********************************************************************
ingresarElemento:
		lea dx,[ingresarConjunto]
		call imprimirMensaje
		call ejecutarEnter

		lea dx,[ingresarElemento]
		call imprimirMensaje
		call ejecutarEnter

		ret

;----------------------------------------------------------------------
;  FIN Ingresar valores a los conjuntos
;----------------------------------------------------------------------

;----------------------------------------------------------------------
;  Funciones generales
;----------------------------------------------------------------------
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

;----------------------------------------------------------------------
;  FIN Funciones generales
;----------------------------------------------------------------------