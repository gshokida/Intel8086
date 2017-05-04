;****************************************************************************************************
; matriz.asm
; Solicita el ingreso de nro de fila, columna y un elemento y lo guarda en la matriz
; Luego imprime una matriz por pantalla recorriendo elemnto por elemento
; aplicando la formula de acceso a matrices.
;****************************************************************************************************

segment pila	stack
   resb 64

segment datos data

fila		dw 1
colu		dw 1
nextLine	db 10,13,"$"

longFila	   dw 10
longElem	   dw 1
cantFilas	dw 10
cantColum	dw 10
;matriz      times 10 resb 10 ;para definir la matriz vacia
matriz     times 100 db '*'  ;matriz inicializada con *

iniFila		dw 0

msgIngF		db "Ingrese fila: $"
msgIngC		db "Ingrese comlumna: $"
msgIngElem	db "Ingrese elemento: $"
elem        resb 1


segment codigo code
..start:
	mov		ax,datos	   ;ds <-- dir del segmento de datos
	mov		ds,ax
	mov		ax,pila		;ss <-- dir del segmento de pila
	mov		ss,ax
   
	;Muestro mensaje para ingresar FILA
	lea	dx,[msgIngF]
	mov	ah,9
	int	21h

	mov	ah,1		;se ingresa la fila por teclado
	int	21h

	;*********************************
	;VALIDAR VALOR INGRESADO PARA FILA
	;*********************************

	xor	ah,ah
	sub	al,48		;transformo a BPF s/s el valor ingresado
	mov	word[fila],ax


	;Muestro mensaje para ingresar COLUMNA
	lea	dx,[msgIngC]
	mov	ah,9
	int	21h

	mov	ah,1		;se ingresa la columna por teclado
	int	21h
	
	;************************************
	;VALIDAR VALOR INGRESADO PARA COLUMNA
	;************************************

	xor	ah,ah
	sub	al,48		;transformo a BPF s/s el volor ingresado
	mov	word[colu],ax

	;Muestro mensaje para ingresar ELEMENTO
	lea	dx,[msgIngElem]
	mov	ah,9
	int	21h

	mov	ah,1		;se ingresa el elemento a guardar por teclado
	int	21h

	mov	byte[elem],al

	;GUARDO ELEMENTO EN POSICION DE MATRIZ
	mov	ax,[fila]
	dec	ax		      ; ax = fila-1
	;imul	10          ; NO ENSAMBLA!!, no puede ser un operando inmediato
	imul	word[longFila]  ; (fila-1)*long fila -- queda en ax

	mov	word[iniFila],ax
	
	mov	ax,[colu]
	dec	ax          ; ax = colu-1
	imul	word[longElem]  ; (colu-1)*long elemento -- queda en ax

	mov	si,[iniFila]      ; posiciono 'si' al inicio de la fila
	add	si,ax		         ; le sumo desplazamiento en columna -En 'si' me queda el dasplazamiento total
	
	mov	dl,[elem]
	mov	byte[matriz+si],dl	;pongo el elemnto en la matriz
	
	;**Imprimo un 'enter' para bajar un renglon
	lea	dx,[nextLine]
	mov	ah,9
	int	21h


	;**IMPRIMO LA MATRIZ**
	mov	word[fila],1
	mov	word[colu],1
NextFila:

	mov	ax,[fila]
	dec	ax		      ; ax = fila-1
	imul	word[longFila]  ; (fila-1)*long fila -- queda en ax

	mov	[iniFila],ax
NextCol:
	mov	ax,[colu]
	dec	ax		      ; ax = colu-1
	imul	word[longElem]  ; (colu-1)*long elemento -- queda en ax

	mov	si,[iniFila]
	add	si,ax		   ; en 'si' me queda el dasplazamiento
	
	mov	dl,[matriz+si]	;pongo el elemnto a imprimir en dl
	mov	ah,2
	int	21h		      ;imprimo elemento

	inc	word[colu]
	mov	cx,[colu]
	cmp	cx,[cantColum]
	jng	NextCol

	;**Imprimo un 'enter' para bajar un renglon
	lea	dx,[nextLine]
	mov	ah,9
	int	21h
	
	;**me muevo al inicio de la columna para la sgte fila
	mov	word[colu],1

	inc	word[fila]
	mov	cx,[fila]
	cmp	cx,[cantFilas]
	jng	NextFila

	mov	ax,4c00h
	int	21h