;*******************************************************************************
; InpStr.asm
; Ejercicio que lee un string de teclado y lo imprime por pantalla
; Toma en cuenta si se presionan las sgtes teclas respetando su funcionamiento:
;  - Enter (lo toma como fin del ingreso)
;  - Backspace (borra el ultimo caracter ingresado)
;  
;*******************************************************************************

segment pila stack
   resb 1024
segment datos data

cadena   times 10 db	' '
         db '$'
msgMues  db  "Ud ingreso: $"

segment codigo code
..start:
	mov	ax,datos	   ;ds <-- dir del segmento de datos
	mov	ds,ax
	mov	ax,pila		;ss <-- dir del segmento de pila
	mov   ss,ax

	mov  si,0		;Reg SI apunta al ppio de la cadena
nextChar:
	;Leo un caracter del teclado (queda en AL)
	mov  ah,8h		
	int  21h

	cmp  al,13		;presionó enter?
	je   finIng
	
	cmp  al,8		;presionó back space?
	jne   noBorra
	
	cmp  si,0		;presionó backspace al inicio?
	je   nextChar
	dec   si
	mov  byte[cadena+si],' '	;borro caracter ingresado anteriormente
	

	;Imprimo backspace (vuelve para atras el cursor)
	mov  dl,al
	mov  ah,2
	int  21h	

	;Imprimo un espacio en blanco para q borre el caracter anterior
	mov  dl,32
	mov  ah,2
	int  21h	

	;Imprimo de nuevo el backspace para q el cursor quede en la posicion del caracter borrado
	mov  dl,8
	mov  ah,2
	int  21h	

	jmp  nextChar

noBorra:	
	;Copio en la cadena el caracter ingresado
	mov  [cadena+si],al
	;Imprimo en pantalla el caracter ingresado
	mov  dl,al		; dl <-- caracter ascii a imprimir
	mov  ah,2
	int  21h	
	
	;Me fijo si es el fin de la cadena
	inc  si
	cmp  si,10
	jl  nextChar

finIng:
	mov  byte[cadena+si],'$'
	
	mov  dx,msgMues		   ;dx <-- offset de 'msgMues' dento del segmento de datos
	mov  ah,9					; servicio 9 para int 21h -- Impmrimir msg en pantalla
	int  21h

	mov  dx,cadena
	mov  ah,9
	int  21h

	mov  ax,4c00h
	int  21h