segment datos data

		octalEnPantalla	db 'Muestro el octal en pantalla.','$'
		
		valorHardcode	db '0F00','$'

		valorBinario	resw 1
		
		char   			resb 1
		
		vector	 		times 6 resb 1
		
		; Para el enter
		salto 			db 13,10,'$'
		
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
		lea dx,[valorHardcode]
		call imprimirMensaje

		
hexaToBinario:
		; almaceno en cx el hexa transformado en binario
		mov cx,0
		
		;contador para loop
		mov	si,0
		
otroHexaToBinario:
		;dl <- elemento del vector apuntado por bx+si
		mov	dl,[valorHardcode+si]			
		
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

copiarAlVector:
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
		
		lea dx,[octalEnPantalla]
		call imprimirMensaje
		
mostrarHexaPantalla:
		mov si,0
		lea	bx,[vector]			;bx <- desplaz del vector dentro del segmento de datos
otroHexaEnPantalla:
		mov	dl,[bx+si]
		mov	ah,2					;Imprimo el elemento (de 'dl') en pantalla
		int	21h
		
		add	si,1					; me posiciono en el sgte elemento del vector
		cmp	si,6
		jl	otroHexaEnPantalla
	
finPrograma:
		mov ah,4Ch
		int 21h

		
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