segment datos data
		; Mensajes
		msjInicial		db 'Iniciando aplicacion...','$'
		msjFinal		db 'Fin del programa','$'
		menuOpciones    db  'Seleccionar opcion [1-3]','$'
		msjIngresoHex   db '1) Ingresar numero Hexadecimal (MAX: 4 digitos)','$'
		msjIngresoOct   db '2) Ingresar numero Octal (MAX 5 digitos)','$'
		msjIngresoOut   db '3) Salir','$'
		msjConvertOct   db 'Convertir a Octal: ','$'
		msjConvertHex   db 'Convertir a Hexadecimal','$'
		msjErrOpen		db 'Error en apertura','$'
		
		msjOctal 		db 'Ingrese su numero en octal (MAX 5 digitos)','$'
		msjHexa			db 'Ingrese su numero en hexa (MAX: 4 digitos)','$'
		
		msjOctalToHexa	db 'Su numero en hexa es:','$'
		msjHexaToOctal	db 'Su numero en octal es:','$'
		
		msjOctalMal		db 'Numero octal mal ingresado maximo 5 digitos','$'
		msjHexaMal		db 'Numero hexadecimal mal ingresado maximo 4 digitos','$'
	
		msjSeparador    db '-----------------------------------------------------------','$'
		
		; String ingresado que representa un octal o hexa
						db 6
						db 0
		cadena 			times 6 resb 1
		
		;Guarda la longitud de la cadena ingresada
		longitud  		resb 1
		
		; Guarda la opcion seleccionada del menu
		menuInput  		resb 1
						db  '$'
		
		; Para el enter
		salto 			db 13,10,'$'
		
		valorBinario	resw 1
		
		char   			resb 1
		
		vector	 		times 6 resb 1

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
		lea dx,[msjInicial]
		call imprimirMensaje

menu:
		call imprimirMenu
		call elegirOperacion
			
finPrograma:
		call imprimirEnter
		lea dx,[msjFinal]
		call imprimirMensaje
		mov ah,4Ch
		int 21h

;**********************************************************************
; Segun lo seleccionado el menu realizo la operacion pedida
;**********************************************************************
elegirOperacion:
		; Ingresar opcion [1-3]
		mov ah,1
		int 21h
		
		call limpiarValorAMostrar
		
		;obtengo la opcion ingresada		
		mov byte[menuInput],al
		
		cmp  byte[menuInput],'1'
		je   ingresoHexaToBinary
		
		cmp  byte[menuInput],'2'
		je   ingresoOctalToBinary
		
		cmp  byte[menuInput],'3'
		je  finPrograma
		
		lea dx,[msjSeparador]
		call imprimirMensaje
		
		jne menu


limpiarValorAMostrar:
		mov si,0
limpiarOtro:
		mov byte[vector+si],' '
		add	si,1
		cmp	si,6
		jl	limpiarOtro
		ret
		
;**********************************************************************
; Transformo el numero ingresado en binario
;**********************************************************************
ingresoOctalToBinary:
		call imprimirEnter
		lea dx,[msjOctal]
		call imprimirMensaje
		
		; cargo desplaz del buffer
		lea dx,[cadena-2] 
		;ingreso de cadena
		mov ah,0ah
		int 21h 

		mov ax,0
		;copia la longitud de los caracters ingresados
		mov al,[cadena-1]		
		mov si,ax
		
		;agrego el fin de la cadena
		mov byte[cadena+si],'$' 

		; Lo almaceno en longitud
		mov bx,si
		mov byte[longitud],bl

		; TODO VALIDAR 
		cmp byte[longitud],5h
		jg octalMalIngresado

		call completarOctal
		
		lea dx,[msjOctalToHexa]
		call imprimirMensaje
		
		call octalToBinario

		lea dx,[msjSeparador]
		call imprimirMensaje
		
		jmp menu

;**********************************************************************
; Relleno con cero los valores que no tengo
;**********************************************************************
completarOctal:
		mov al,byte[longitud]
		cmp al,5h
		je  salirCompletarOctal
otroCompletarOctal:
		mov di,3
		lea	bx,[cadena]	

shiftOctal:
		mov cx,[bx+di]
		mov [bx+di+1],cx
		sub di,1
		cmp di,0
		jg shiftOctal
		je shiftOctal
		mov byte[cadena],30h
		
		add al,1h
		cmp al,5h
		jl otroCompletarOctal
salirCompletarOctal:
		lea dx,[cadena]
		call imprimirMensaje
		ret

;**********************************************************************
; Transformo de octal a binario
;**********************************************************************
octalToBinario:
		; almaceno en cx el octal transformado en binario
		mov cx,0
		;contador para loop
		mov	si,0
		
otroOctalToBinario:
		;dl <- elemento del vector apuntado por bx+si
		mov	dl,[cadena+si]			
		
		; le resto 30 para transformarlo en binario
		sub dl,30h
		
		; pongo en cero dh 
		mov dh,0
		
		;corro 3 posiciones al bx 
		shl cx,3
		add cx,dx
		
		; me posiciono en el siguiente elemento del vector
		add	si,1					
		cmp	si,5
		jl	otroOctalToBinario

		;paso lo que tengo en bx a val
		mov word[valorBinario],cx

;**********************************************************************
; Transformo de binario a hexa
;**********************************************************************
binarioToHexa:
		mov al,0
		mov si,5
		
otroBinarioToHexa:
		; me traigo el valor de memoria
		mov cx,[valorBinario]
		
		; solo uso los 4 bits que necesito para el hexa
		shl cx,12
		shr cx,12
		
		;obtengo el caracter en ASCIIs
		cmp cl,9h
		jg sumarPorSerLetra
		add cl,30h
		jmp copiarAlVectorHexa
		
sumarPorSerLetra:
		add cl,37h

copiarAlVectorHexa:
		; lo copio en el vector
		mov byte[vector+si],cl
		
		; corro 4 bits para quitar los que ya vi y lo guardo
		mov cx,[valorBinario]
		shr cx,4
		mov word[valorBinario],cx
		
		; me posiciono en el siguiente elemento del vector
		sub si,1
		add	al,1					
		cmp	al,4
		jl	otroBinarioToHexa

		mov si,0
		lea	bx,[vector]			;bx <- desplaz del vector dentro del segmento de datos
otroHexaEnPantalla:
		mov	dl,[bx+si]
		mov	ah,2					;Imprimo el elemento (de 'dl') en pantalla
		int	21h
		
		add	si,1					; me posiciono en el sgte elemento del vector
		cmp	si,6
		jl	otroHexaEnPantalla
		call imprimirEnter
		ret

;**********************************************************************
; Imprimo el error de numero mal ingresado
;**********************************************************************
octalMalIngresado:
		call imprimirEnter
		lea dx,[msjOctalMal]
		call imprimirMensaje

		lea dx,[msjSeparador]
		call imprimirMensaje

		jmp menu

;**********************************************************************
; Transformo el numero ingresado en binario
;**********************************************************************
ingresoHexaToBinary:
		call imprimirEnter
		lea dx,[msjHexa]
		call imprimirMensaje
		
		; cargo desplaz del buffer
		lea dx,[cadena-2] 
		;ingreso de cadena
		mov ah,0ah
		int 21h 

		mov ax,0
		;copia la longitud de los caracters ingresados
		mov al,[cadena-1]		
		mov si,ax
		
		;agrego el fin de la cadena
		mov byte[cadena+si],'$' 

		; Lo almaceno en longitud
		mov bx,si
		mov byte[longitud],bl

		; TODO VALIDAR
		cmp byte[longitud],4h
		jg hexaMalIngresado

		call completarHexa

		lea dx,[msjHexaToOctal]
		call imprimirMensaje
		
		call hexaToBinario

		lea dx,[msjSeparador]
		call imprimirMensaje
		jmp menu

;**********************************************************************
; Relleno con cero los valores que no tengo
;**********************************************************************
completarHexa:
		mov al,byte[longitud]
		cmp al,4h
		je  salirCompletarHexa
otroCompletarHexa:
		mov di,2
		lea	bx,[cadena]	

shiftHexa:
		mov cx,[bx+di]
		mov [bx+di+1],cx
		sub di,1
		cmp di,0
		jg shiftHexa
		je shiftHexa
		mov byte[cadena],30h
		
		add al,1h
		cmp al,4h
		jl otroCompletarHexa
salirCompletarHexa:
		lea dx,[cadena]
		call imprimirMensaje
		ret

;**********************************************************************
; Transformo de hexa a binario
;**********************************************************************
hexaToBinario:
		; almaceno en cx el hexa transformado en binario
		mov cx,0
		;contador para loop
		mov	si,0
		
otroHexaToBinario:
		;dl <- elemento del vector apuntado por bx+si
		mov	dl,[cadena+si]			
		
		cmp dl,39h
		jg restarMasPorSerLetra
		; le resto 30 para transformarlo en binario
		sub dl,30h
		jmp seguirHexaToBin
		
restarMasPorSerLetra:
		sub dl,37h
		
seguirHexaToBin:
		; pongo en cero dh 
		mov dh,0
		
		;corro 4 posiciones al cx 
		shl cx,4
		add cx,dx
		
		; me posiciono en el siguiente elemento del vector
		add	si,1					
		cmp	si,4
		jl	otroHexaToBinario
		
		;paso lo que tengo en bx a val
		mov word[valorBinario],cx

;**********************************************************************
; Transformo de binario a octal
;**********************************************************************		
binarioToOctal:
		mov al,0
		mov si,5
		
otroBinarioToOctal:
		; me traigo el valor de memoria
		mov cx,[valorBinario]
		
		; solo uso los 3 bits que necesito para el hexa
		shl cx,13
		shr cx,13
		
		;obtengo el caracter en ASCIIs
		add cl,30h

		; lo copio en el vector
		mov byte[vector+si],cl
		
		; corro 3 bits para quitar los que ya vi y lo guardo
		mov cx,[valorBinario]
		shr cx,3
		mov word[valorBinario],cx
		
		; me posiciono en el siguiente elemento del vector
		sub si,1
		add	al,1					
		cmp	al,6
		jl	otroBinarioToOctal
		
mostrarOctalPantalla:
		mov si,0
		lea	bx,[vector]			;bx <- desplaz del vector dentro del segmento de datos
otroOctalEnPantalla:
		mov	dl,[bx+si]
		mov	ah,2					;Imprimo el elemento (de 'dl') en pantalla
		int	21h
		
		add	si,1					; me posiciono en el sgte elemento del vector
		cmp	si,6
		jl	otroOctalEnPantalla
		call imprimirEnter
		ret

;**********************************************************************
; Imprimo el error de numero mal ingresado
;**********************************************************************
hexaMalIngresado:
		lea dx,[msjHexaMal]
		call imprimirMensaje

		lea dx,[msjSeparador]
		call imprimirMensaje

		jmp menu

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
		call imprimirEnter
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