segment datos data

		; Para el enter
		salto 			db 13,10,'$'
		
		; Numero empaquetado
		numeroEmpa		dw 15fh
		
		; Numero binario
		numeroBinario	resw 1
		
		; Numero a mostrar
		numero 			times 2 db '0'
						db '$'
		
		; Para mostrar la fecha en la consola
		convertNum		times 4 db '0'
		                db '$'
		
		; Para realizar la conversion a string
		diez			dw  10
		
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
		
		
		
		
		
finPrograma:
		mov ah,4Ch
		int 21h

		
;**********************************************************************
; Convierto a string el numero para mostrar
;**********************************************************************
mostrarNumero:
		mov  dx,0
		mov  ax,[numeroBinario]
		mov  si,1
		call divisionesSucesivas
		mov al,[convertNum]
		mov [numero],al
		mov al,[convertNum+1]
		mov [numero+1],al
		
divisionesSucesivas:
		div  word[diez]      		;dx:ax div 10 ==> dx <- resto & ax <- cociente
		add  dx,48		      		;convierto a Ascii el resto
		mov  [convertNum+si],dl	 	;lo pongo en la posicion anterior
		sub  si,1		      		;posiciono SI en el caracter anterior en la cadena
		cmp  ax,[diez]				;IF    cociente < 10
		jl   finDivision			;THEN  fin division
		mov  dx,0					;pongo en 0 DX para la dupla DX:AX
		jmp  divisionesSucesivas
finDivision:
		add  ax,48
		mov  [convertNum+si],al
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