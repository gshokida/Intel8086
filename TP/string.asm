segment datos data
		valor1	db 'A3','$'
		
		caracter db 'H'
				
		char resb 1
		
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
		
		mov  si,0
		mov  dl,byte[valor1+si]
		mov  ah,2
		int  21h
		
		call ejecutarEnter
		mov   bx,0
		inc  si
		mov  dl,byte[valor1+bx+si]
		mov  ah,2
		int  21h
		
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
