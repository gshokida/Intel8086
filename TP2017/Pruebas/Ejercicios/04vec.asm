;*********************************************************************
; vec.asm
; Ejercicio que recorre un vector e imprime sus elementos por pantalla
; El mismo codigo sirve para recorrer un string
;
;*********************************************************************
segment pila	stack
      	  resb 64

segment datos data

vector	 times 10 db 'A'
;vector  db  "123456789D"		;Este PGM tambien sirve para imprimir un string caracter a caracter

segment codigo code
..start:
	mov	ax,datos				;ds <- dir del segmento de datos
	mov	ds,ax
	mov	ax,pila				;ss <- dir del segmento de pila
	mov	ss,ax
	
	mov	si,0					;contador para loop
	lea	bx,[vector]			;bx <- desplaz del vector dentro del segmento de datos
	
otro:
	mov	dl,[bx+si]			;dl <- elemento del vector apuntado por bx+si
;	mov	dl,[vector +si]	;ESTA LINEA PUEDE REEMPLAZAR A LAS 2 ANTERIORES
	mov	ah,2					;Imprimo el elemento (de 'dl') en pantalla
	int	21h

	add	si,1					; me posiciono en el sgte elemento del vector
	cmp	si,10
	jl	otro

   ;Retorno al DOS
	mov	ax,4c00h				; retornar al DOS
	int	21h
