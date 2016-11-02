segment datos data
	menuIngresar	db '1) Ingresar un numero$'
	menuSalir		db 'A) Salir$'

	menuOpcionNoValida		db 'Debe ingresar 1 o A$'
	
	ingresarValor	db 'Ingrese un valor entre 1 y 6$'
	
	ingresarCorrecto db 'Ha ingresado un numero valido$'
	ingresarIncorrecto db 'Debe ingresar un numero entre 1 y 6$'
	
	valor resb 1
	
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
		je  ingresar
		
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
		
	
ingresar:
		lea dx,[ingresarValor]
		call imprimirMensaje
		call ejecutarEnter
		
		mov ah,1
		int 21h
		mov byte[valor],al
		
		call validar
		jmp inicio

validar:
		cmp  byte[valor],'1'
		jl  imprimirValido
		cmp  byte[valor],'6'
		jg  imprimirNoValido
imprimirValido:
		lea dx,[ingresarCorrecto]
		call imprimirMensaje
		call ejecutarEnter
		jmp volverValidar
imprimirNoValido:
		lea dx,[ingresarIncorrecto]
		call imprimirMensaje
		call ejecutarEnter
volverValidar:
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
