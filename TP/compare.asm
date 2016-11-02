segment datos data
		valor1	db 'AB','$'
		valor2	resb 3
		
				db 3
				db 0
		elemento times 3 resb 1
		
		menuIngresar	db 'Ingresar un elemento$'
		
		menuIgual		db 'Igual$'
		menuDistinto	db 'Distinto$'
		
		menuFin db 'FIN$'
		
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
		lea dx,[menuIngresar]
		call imprimirMensaje
		call ejecutarEnter
		
		lea dx,[elemento-2]
		mov ah,0ah
		int 21h
		
		mov ax,0
		mov al,[elemento-1]
		mov si,ax
		mov byte[elemento+si],'$' ; piso el 0Dh con el '$'para indicar fin de string para imprimir
		
		lea dx,[elemento]
		call imprimirMensaje
		call ejecutarEnter
		
		lea dx,[valor1]
		call imprimirMensaje
		call ejecutarEnter
		
		mov cx,3
		lea si,[elemento]
		lea di,[valor2]
		rep movsb
		
		;mov cx,1
		;mov si,valor1
		;mov di,elemento
		;repe cmpsw
		mov cx,2
		mov si,valor1
		mov di,valor2
		repe cmpsb
		je igual
		lea dx,[menuDistinto]
		call imprimirMensaje
		call ejecutarEnter
		jmp fin
		
igual:
		lea dx,[menuIgual]
		call imprimirMensaje
		call ejecutarEnter

fin:
		lea dx,[menuFin]
		call imprimirMensaje
		call ejecutarEnter

salir:		
		mov ah,4ch
		int 21h

imprimirMensaje:
		mov ah,9
		int 21h
		ret

ejecutarEnter:
		mov dx,salto
		mov ah,9h
		int 21h
		ret
