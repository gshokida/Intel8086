;*********************************************************************
; sum.asm
; Ejercicio que suma 2 numeros
;
;*********************************************************************

segment pila	stack
      	  resb 64

segment datos data
	n1	db  5
	n2	db  4

segment codigo code
..start:
	mov	ax,datos	   ;ds <- dir del segmento de datos
	mov	ds,ax
	mov	ax,pila		;ss <- dir del segmento de pila
	mov	ss,ax
	
	mov  	al,[n1]		;copio n1 en 'al' porque no se pueden sumar 2 operandos en memoria
	add 	al,[n2]		;sumo  n1(al)+n2 y resultado queda en 'al'
	mov  	[n1],al		;copio en n1 el resultado 

	mov	dl,[n1]
	add	dl,30h		;sumo 30 para poder imprimir el resultado
	mov	ah,2
	int	21h

   ;Retorno al DOS
	mov  	ax,4c00h	;retorno al DOS
	int  	21h
