segment datos data
		
		matriz times 120 db '!!$'
		
		elemento db '1A$'
		
		elementoMatriz resb 2
						db '$'
						
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
		mov bx,3
		mov cx,2
		lea si,[elemento]
		lea di,[matriz+bx]
		rep movsb
		
		call recorrerMatriz
		
finPrograma:
		mov ah,4ch
		int 21h
		
		
recorrerMatriz:
		mov bx,0
		mov si,0
		mov cx,6
recorrerFilas:
			mov di,20
recorrerColumnas:
			mov word[elementoMatriz],[matriz+bx+si]
			
			lea dx,[elementoMatriz]
			mov ah,9
			int 21h
			
			add si,3
			dec di
			jnz recorrerColumnas
			call ejecutarEnter
			mov si,0
			add bx,60
		loop recorrerFilas
		
		ret
		
ejecutarEnter:
		mov dx,salto
		mov ah,9h
		int 21h
		ret