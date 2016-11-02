segment datos data
		
		matriz times 120 db '||$'
		
		elemento db '4A$'
						
		salto db 13,10,'$'
		
		contador db 1
		
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
		mov word[elemento],"CC"
		
		lea dx,[elemento]
		mov ah,9
		int 21h
		
		call ejecutarEnter
		
		mov bx,0
		
		;mov cx,3
		;lea si,[elemento]
		;lea di,[matriz+bx]
		;rep movsb
		
		;mov word[matriz+bx],"CC"
		
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
		
		call recorrerMatriz
		
finPrograma:
		mov ah,4ch
		int 21h
		
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
		
ejecutarEnter:
		mov dx,salto
		mov ah,9h
		int 21h
		ret