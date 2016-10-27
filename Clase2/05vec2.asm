;*********************************************************************
; vec2.asm
; Ejercicio que ingreso por teclado para llenar un vector y luego
; lo recorre y lo imprime por pantalla
;
;*********************************************************************
segment pila	stack
      	  resb 64

segment datos data
	vector   resb 10
	msgIng   db  10,13,"Ingrese elemento para posicion $"

segment codigo code
..start:
	mov	ax,datos					;ds <- dir del segmento de datos
	mov	ds,ax
	mov	ax,pila					;ss <- dir del segmento de pila
	mov	ss,ax

	mov	si,0						;puntero al elemento corriente del vector
otroIn:
	lea	dx,[msgIng]				; Imprimo msg para ingreso
	mov	ah,9
	int	21h
	
	mov	dx,si						; copio el puntero en DX (queda en DL el valor de la posicion)
	add	dl,48						; convierto a ascii el nro del elemento a ingresar

	mov	ah,2						; imprimo el nro del elemento a ingresar
	int	21h

	mov	ah,1						; ingreso por teclado el elemento
	int	21h

	mov	[vector + si],al	   ; guardo el elemento en el vector

	add	si,1						; me adelanto en el vector
	cmp	si,10
	jl	otroIn

	mov	si,0						;puntero al elemento corriente del vector
	mov	cx,10						;contador para loop
otro:
	mov	dl,[vector + si]	   ; copio en 'dl' el elemento del vector a imprimir
	mov	ah,2						; imprimo el elemento del vec
	int	21h

	add	si,1						; me adelanto al prox elemento

	loop	otro						; resta 1 a cx y si es <> 0 bifurca a 'otro'
	
   ;Retorno al DOS
	mov	ax,4c00h	
	int	21h
