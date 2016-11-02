segment datos data
		
		matriz times 120 db '||$'
		
		elemento db '4A$'
						
		salto db 13,10,'$'
		
		contador db 1
		
		mensajeIngresoConjunto db 'Ingresar conjunto a mostrar del 1 al 6$'
		
		numeroConjuntoChar resb 1
		numeroConjuntoNum resb 1
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
		call llenarMatriz
		
		call pedirIngresoConjunto
		
		
		;call recorrerMatriz
		
finPrograma:
		mov ah,4ch
		int 21h

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
		mov ah,9
		int 21h
		
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
; Imprimo un enter en la pantalla
;----------------------------------------------------------------------		
ejecutarEnter:
		mov dx,salto
		mov ah,9h
		int 21h
		ret