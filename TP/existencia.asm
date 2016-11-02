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
		
		matriz times 120 db '  $'
						db '$'
		
		vector times 6 db 1
		
				db 3
				db 0
		elemento resb 3
						
		salto db 13,10,'$'
		
		contador db 1
		
		flagElemento resb 1  ; si vale V: Valido. F: No Valido
		
		mensajeIngresoConjunto db 'Ingresar conjunto del 1 al 6$'
		mensajeIngresoElemento db 'Ingrese un elemento valido$'
		
		ingresarCorrecto db 'Ha ingresado un elemento valido$'
		ingresarIncorrecto db 'Debe ingresar un elemento valido 2 digitos alfanumericos$'
		
		mensajeConjuntoLleno db 'El conjunto ya está lleno$'
		
		numeroConjuntoChar resb 1
		contadorConjunto db "1"
		conjuntoValido resb 1
		
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

		call  imprimirMenu 
		
		;opcion [1-5]
		mov ah,1
		int 21h

		;obtengo la opcion ingresada		
		mov byte[menuOpcion],al

		cmp  byte[menuOpcion],'1'
		je   ingresarElemento
		
		cmp  byte[menuOpcion],'2'
		je   existenciaElemento
		
		cmp  byte[menuOpcion],'3'
		je  inicio

		cmp  byte[menuOpcion],'4'
		je   inicio
		
		cmp  byte[menuOpcion],'5'
		je  finPrograma

		call imprimirMenuOpcionInvalida
		jmp inicio
		
finPrograma:
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

;**********************************************************************
;Imprimir opción no valida del menu
;**********************************************************************
ingresarElemento:
		call pedirIngresoConjunto
		
		call pedirIngresoElemento
		
		call agregarElemento
		
		call recorrerMatriz
		
		ret


;----------------------------------------------------------------------
; Lleno la matriz con otros valores
;----------------------------------------------------------------------
llenarMatriz:
		mov bx,0
		mov ax,[elemento]
		mov word[matriz+bx],ax
		
		mov bx,63
		mov word[matriz+bx],ax
		
		mov bx,126
		mov word[matriz+bx],ax
		
		mov bx,189
		mov word[matriz+bx],ax
		
		mov bx,252
		mov word[matriz+bx],ax
		
		mov bx,315
		mov word[matriz+bx],ax
		
		ret

;----------------------------------------------------------------------
; Pido el ingreso del conjunto del 1 al 6 y valido
;----------------------------------------------------------------------
pedirIngresoConjunto:
		lea dx,[mensajeIngresoConjunto]
		call imprimirMensaje
		
		mov ah,1
		int 21h
		mov [numeroConjuntoChar],al
		
		call ejecutarEnter
		
		call validarIngresoConjunto
		
		cmp byte[conjuntoValido], "F"
		je pedirIngresoConjunto
		
		ret

validarIngresoConjunto:
		mov byte[conjuntoValido], "V"
		cmp byte[numeroConjuntoChar],"1"
		jl ingresoConjuntoNoValido
		cmp byte[numeroConjuntoChar],"6"
		jg ingresoConjuntoNoValido
finValidarIngresoConjunto:
		ret
		
ingresoConjuntoNoValido:
		mov byte[conjuntoValido], "F"
		jmp finValidarIngresoConjunto


;----------------------------------------------------------------------
; Pido el ingreso del elemento a agregar
;----------------------------------------------------------------------
pedirIngresoElemento:
		;pido el ingreso del elemento
		lea dx,[mensajeIngresoElemento]
		call imprimirMensaje
		call ejecutarEnter
		;leo el elemento ingresado
		lea dx,[elemento-2]
		mov ah,0ah
		int 21h
		;para finalizar la cadena con $
		mov ax,0
		mov al,[elemento-1]
		mov si,ax
		mov byte[elemento+si],'$'
		
		call validarElemento
		
		cmp  byte[flagElemento],"V"
		je  elementoValido
		lea dx,[ingresarIncorrecto]
		call imprimirMensaje
		call ejecutarEnter
		jmp  pedirIngresoElemento
elementoValido:
		lea dx,[ingresarCorrecto]
		call imprimirMensaje
		call ejecutarEnter
		ret
		
;----------------------------------------------------------------------
; Valido el elemento que quiere ingresar
;----------------------------------------------------------------------
validarElemento:
		mov si,0
		mov dl,byte[elemento+si]
		call validarDigitoElemento
		cmp  byte[flagElemento],"F"
		je  finValidarElemento
		inc si
		mov dl,byte[elemento+si]
		call validarDigitoElemento
finValidarElemento:
		ret
		
validarDigitoElemento:
		cmp dl,'0'
		jl  noEsNumero
		cmp dl,'9'
		jg  noEsNumero
		mov byte[flagElemento],"V"
		jmp finValidarDigitoElemento
noEsNumero:
		cmp dl,'A'
		jl  noEsLetra
		cmp dl,'Z'
		jg  noEsLetra
		mov byte[flagElemento],"V"
		jmp finValidarDigitoElemento
noEsLetra:
		mov byte[flagElemento],"F"
finValidarDigitoElemento:
		ret

;----------------------------------------------------------------------
; Agrego el elemento al conjunto
;----------------------------------------------------------------------
agregarElemento:
		mov bh,[contadorConjunto]
		mov si,0
siguienteAgregarConjunto:
		cmp byte[numeroConjuntoChar],bh
		jg avanzarAgregarConjunto
		
		mov byte[contador],0
sigienteElementoAgregarConjunto:
		inc byte[contador]
		;Ver si es "  " si es igual grabo el elemento y salgo con finAgregarConjunto
		cmp word[matriz+si],"  "
		jne siguientePosicionAgregar
		mov ax,[elemento]
		mov word[matriz+si],ax
		jmp finAgregarConjunto
siguientePosicionAgregar:
		add si,3
		cmp byte[contador],20
		jge conjuntoLleno
		jmp sigienteElementoAgregarConjunto
conjuntoLleno:
		lea dx,[mensajeConjuntoLleno]
		call imprimirMensaje
		call ejecutarEnter
finAgregarConjunto:
		mov byte[contadorConjunto],"1"
		ret
		
avanzarAgregarConjunto:
		add si,60
		add bh,1
		jmp siguienteAgregarConjunto

agregoElementoEnPosicion:
		
		
;----------------------------------------------------------------------
; Muestro el conjunto que elijo
;----------------------------------------------------------------------
mostrarConjunto:
		mov bh,[contadorConjunto]
		mov si,0
siguienteConjunto:
		cmp byte[numeroConjuntoChar],bh
		jg avanzarConjunto
		
		mov byte[contador],0
sigienteElementoConjunto:
		inc byte[contador]
		lea dx,[matriz+si]
		call imprimirMensaje
		add si,3
		cmp byte[contador],20
		jge finMostrarConjunto
		jmp sigienteElementoConjunto
finMostrarConjunto:
		call ejecutarEnter
		mov byte[contadorConjunto],"1"
		ret
		
avanzarConjunto:
		add si,60
		add bh,1
		jmp siguienteConjunto

;----------------------------------------------------------------------
; Recorro la matriz y la muestro
;----------------------------------------------------------------------
recorrerMatriz:
		mov bx,0
		mov si,0
		mov cx,360
		mov byte[contador],0
sigienteElemento:
		inc byte[contador]
		lea dx,[matriz+si]
		mov ah,9
		int 21h
		add si,3
		cmp byte[contador],20
		je imprimirFinColumna
vuelvoElemento:
		sub cx,3
		jnz sigienteElemento
		ret
imprimirFinColumna:
		call ejecutarEnter
		mov byte[contador],0
		jmp vuelvoElemento

;----------------------------------------------------------------------
; Verificar existencia de elemento en conjunto
;----------------------------------------------------------------------
existenciaElemento:
		call pedirIngresoConjunto
		
		call pedirIngresoElemento
		
		;call existeElemento
		
		call recorrerMatriz
		ret
		
;----------------------------------------------------------------------
; Imprimo un enter en la pantalla
;----------------------------------------------------------------------		
ejecutarEnter:
		mov dx,salto
		mov ah,9h
		int 21h
		ret

;----------------------------------------------------------------------
; Imprimo mensaje
;----------------------------------------------------------------------				
imprimirMensaje:
		mov ah,9
		int 21h
		ret