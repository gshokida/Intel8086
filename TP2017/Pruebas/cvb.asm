segment datos data

		; Para el enter
		salto 			db 13,10,'$'
		
		; Numero empaquetado
		numeroEmpa		dw 321fh
		
		; Numero binario
		total			dw 0
		numeroBinario   db 0
		
		;Multiplicadores
		PrimerDigito    dw 1
		SegundoDigito   dw 10
		TercerDigito   	dw 100
		
		;Dia en formato string
		dia 			times 3 db '0'
						db '$'
		
		; Para realizar la conversion a string
		diez			dw  10
		
		; Para mostrar la fecha en la consola
		convertNum		times 4 db '0'
		                db '$'
						
		
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
		
		;contador en cero
		mov word[total],0
		
		;cargo el valor del empaquetado
		mov dx,word[numeroEmpa]
		;Muevo a izquierda 4 bits al registro bajo dado que cuando se carga en memoria
		;numeroEmpa quedaria 050f como seria en el archivo real 
		shr dl,4
		mov byte[numeroBinario],dl
		mov ax,0
		mov al,byte[numeroBinario]
		mul word[PrimerDigito]
		mov word[total],ax
		
		;Segundo digito
		mov dx,word[numeroEmpa]
		shl dh,4
		shr dh,4
		mov byte[numeroBinario],dh
		mov ax,0
		mov al,byte[numeroBinario]
		mul word[SegundoDigito]
		add word[total],ax
		
		;Segundo digito
		mov dx,word[numeroEmpa]
		shr dh,4
		mov byte[numeroBinario],dh
		mov ax,0
		mov al,byte[numeroBinario]
		mul word[TercerDigito]
		add word[total],ax
		
		;Convertir a string
		mov  dx,0
		mov  ax,word[total]
		mov  si,2
		call divisionesSucesivas
		mov al,[convertNum]
		mov [dia],al
		mov al,[convertNum+1]
		mov [dia+1],al
		mov al,[convertNum+2]
		mov [dia+2],al
		
		; Imprimo la fecha en consola
		lea dx,[dia]
		call imprimirMensaje
		
finPrograma:
		mov ah,4Ch
		int 21h

		
		
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