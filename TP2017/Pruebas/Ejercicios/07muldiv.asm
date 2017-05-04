;****************************************************************************************************
; muldiv.asm
; Ejercicio que hace multimplicaciones y divisiones en sus 2 combinaciones de longitud de operandos
;
;****************************************************************************************************
segment pila	stack
      	  resb 64

segment datos data
	byte1	db  5
	byte2	db  4
	word1	dw  7
	word2	dw  6

segment codigo code
..start:
	mov		ax,datos	   ;ds <-- dir del segmento de datos
	mov		ds,ax
	mov		ax,pila		;ss <-- dir del segmento de pila
	mov		ss,ax
	
	mov   al,[byte1]		;'al' <- byte1
	imul  byte[byte2]		;byte1(al)*byte2 y resultado queda en 'ax'

	mov   ax,word1			;'ax' <- word1
	imul  word[word2]	   ;word1(ax)*word2 y resultado queda en dx:ax

	mov   ax,word1			;'ax' <- word1
	idiv  byte[byte2]		;word1(ax):byte2 -- coc queda en 'al'  y resto en 'ah'

	sub   dx,dx				;dx <- 0
	mov   ax,word1			;'ax' <- word1
	idiv  word[word2]		;word1(dx:ax) : word2 -- coc queda en 'ax' y resto en 'dx'

   ;Retorno al DOS
	mov  	ax,4c00h	;retorno al DOS
	int  	21h
