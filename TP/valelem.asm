segment datos data
	
		menuIngresar	db '1) Ingresar un elemento$'
		menuSalir		db 'A) Salir$'

		menuOpcionNoValida		db 'Debe ingresar 1 o A$'
		
		ingresarValor	db 'Ingrese un elemento de dos digitos [A-Z,0-9]$'
		
		flagElemento resb 1  ; si vale V: Valido. F: No Valido
		
		ingresarCorrecto db 'Ha ingresado un elemento valido$'
		ingresarIncorrecto db 'Debe ingresar un elemento valido 2 digitos alfanumericos$'
		
						 db 3
						 db 0
		elemento times 3 resb 1
		
		valorElemento resb 3
		
		menuOpcion resb 1
					db  '$'
		
		salto db 13,10,'$'
	
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
		
		;opcion [1-A]
		mov ah,1
		int 21h
		
		;obtengo la opcion ingresada		
		mov byte[menuOpcion],al
		
		cmp  byte[menuOpcion],'1'
		je  ingresarElemento
		
		cmp  byte[menuOpcion],'A'
		je  salir
		
		call imprimirMenuOpcionInvalida
		jmp inicio
		
salir:		
		mov ah,4ch
		int 21h
		
		
imprimirMenu:
		lea dx,[menuIngresar]
		call imprimirMensaje
		call ejecutarEnter
	
		lea dx,[menuSalir]
		call imprimirMensaje
		call ejecutarEnter
		ret
		
	
imprimirMenuOpcionInvalida:
		lea dx,[menuOpcionNoValida]
		call imprimirMensaje
		call ejecutarEnter
		ret
		
	
ingresarElemento:
		lea dx,[ingresarValor]
		call imprimirMensaje
		call ejecutarEnter
		
		lea dx,[elemento-2]
		mov ah,0ah
		int 21h
		
		mov ax,0
		mov al,[elemento-1]
		mov si,ax
		mov byte[elemento+si],'$' ; piso el 0Dh con el '$'para indicar fin de string para imprimir
		
		mov cx,3
		lea si,[elemento]
		lea di,[valorElemento]
		rep movsb
		
		call validarElemento
		
		cmp  byte[flagElemento],"V"
		je  elementoValido
		lea dx,[ingresarIncorrecto]
		call imprimirMensaje
		call ejecutarEnter
		jmp  ingresarElemento
elementoValido:
		lea dx,[ingresarCorrecto]
		call imprimirMensaje
		call ejecutarEnter
		jmp inicio

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
		
		
imprimirMensaje:
		mov ah,9
		int 21h
		ret


ejecutarEnter:
		mov dx,salto
		mov ah,9h
		int 21h
		ret
